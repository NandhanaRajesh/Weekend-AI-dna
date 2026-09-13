create extension if not exists pgcrypto;

create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.users add column if not exists email text;
alter table public.users add column if not exists display_name text;
alter table public.users add column if not exists created_at timestamptz not null default now();
alter table public.users add column if not exists updated_at timestamptz not null default now();

create table if not exists public.auth_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  event_type text not null check (event_type in ('sign_up', 'sign_in', 'sign_out')),
  email text,
  occurred_at timestamptz not null default now(),
  metadata jsonb not null default '{}'::jsonb
);

create table if not exists public.preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  mood text,
  squad text,
  budget integer not null default 1500 check (budget >= 0),
  travel_distance numeric(10, 2) not null default 15 check (travel_distance >= 0),
  transport text not null default 'car',
  food_preferences text,
  activity jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.preferences add column if not exists mood text;
alter table public.preferences add column if not exists squad text;
alter table public.preferences add column if not exists updated_at timestamptz not null default now();
alter table public.preferences alter column travel_distance type numeric(10, 2) using travel_distance::numeric;

create table if not exists public.trips (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Weekend plan',
  destination text,
  mood text,
  squad text,
  budget numeric(12, 2) not null default 0 check (budget >= 0),
  travel_distance_km numeric(10, 2) not null default 0 check (travel_distance_km >= 0),
  transport text,
  itinerary jsonb not null default '{}'::jsonb,
  estimated_total numeric(12, 2) not null default 0 check (estimated_total >= 0),
  created_at timestamptz not null default now()
);

create table if not exists public.trip_expenses (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  category text not null,
  description text not null,
  amount numeric(12, 2) not null check (amount >= 0),
  currency char(3) not null default 'INR',
  created_at timestamptz not null default now()
);

create or replace function public.refresh_trip_total()
returns trigger
language plpgsql
as $$
begin
  update public.trips
  set estimated_total = coalesce((
    select sum(amount) from public.trip_expenses where trip_id = coalesce(new.trip_id, old.trip_id)
  ), 0)
  where id = coalesce(new.trip_id, old.trip_id);
  return coalesce(new, old);
end;
$$;

drop trigger if exists trip_expenses_refresh_total on public.trip_expenses;
create trigger trip_expenses_refresh_total
  after insert or update or delete on public.trip_expenses
  for each row execute procedure public.refresh_trip_total();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, email, display_name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1)))
  on conflict (id) do update set email = excluded.email, updated_at = now();
  insert into public.auth_history (user_id, event_type, email)
  values (new.id, 'sign_up', new.email);
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists users_set_updated_at on public.users;
create trigger users_set_updated_at before update on public.users
for each row execute procedure public.set_updated_at();

drop trigger if exists preferences_set_updated_at on public.preferences;
create trigger preferences_set_updated_at before update on public.preferences
for each row execute procedure public.set_updated_at();

alter table public.users enable row level security;
alter table public.auth_history enable row level security;
alter table public.preferences enable row level security;
alter table public.trips enable row level security;
alter table public.trip_expenses enable row level security;

drop policy if exists users_select_own on public.users;
create policy users_select_own on public.users for select using (auth.uid() = id);
drop policy if exists users_update_own on public.users;
create policy users_update_own on public.users for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists auth_history_select_own on public.auth_history;
create policy auth_history_select_own on public.auth_history for select using (auth.uid() = user_id);
drop policy if exists auth_history_insert_own on public.auth_history;
create policy auth_history_insert_own on public.auth_history for insert with check (auth.uid() = user_id);

drop policy if exists preferences_select_own on public.preferences;
create policy preferences_select_own on public.preferences for select using (auth.uid() = user_id);
drop policy if exists preferences_insert_own on public.preferences;
create policy preferences_insert_own on public.preferences for insert with check (auth.uid() = user_id);
drop policy if exists preferences_update_own on public.preferences;
create policy preferences_update_own on public.preferences for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists trips_select_own on public.trips;
create policy trips_select_own on public.trips for select using (auth.uid() = user_id);
drop policy if exists trips_insert_own on public.trips;
create policy trips_insert_own on public.trips for insert with check (auth.uid() = user_id);
drop policy if exists trips_update_own on public.trips;
create policy trips_update_own on public.trips for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists trip_expenses_select_own on public.trip_expenses;
create policy trip_expenses_select_own on public.trip_expenses for select using (auth.uid() = user_id);
drop policy if exists trip_expenses_insert_own on public.trip_expenses;
create policy trip_expenses_insert_own on public.trip_expenses for insert with check (auth.uid() = user_id);