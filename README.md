# weekend_ai

A new Flutter project.

# WeekendAI

## Supabase backend

The app uses Supabase Auth and Postgres. Apply the migration in
`supabase/migrations/20260910000000_backend_foundation.sql` to the project
configured in `lib/config/supabase_config.dart` using the Supabase Dashboard SQL
Editor or the Supabase CLI:

```bash
supabase db push
```

The migration creates protected profile, preference, authentication history,
trip, and trip expense tables. It also creates a profile and sign-up history
row when a Supabase Auth user is created, enables row-level security, and keeps
each trip's `estimated_total` equal to the sum of its expense rows.

Email/password sessions are restored automatically on app launch. Do not call
`auth.signOut()` during startup. Configure email confirmation and redirect URLs
in Supabase Auth settings before testing sign-up on a device.
