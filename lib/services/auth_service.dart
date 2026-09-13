import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class AuthService {
  static SupabaseClient get _client => SupabaseService.client;

  static User? get currentUser => _client.auth.currentUser;

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );
    return response;
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user != null) {
      try {
        await _recordEvent('sign_in', response.user!);
      } catch (_) {
        // A history write must not prevent a valid login from continuing.
      }
    }
    return response;
  }

  static Future<void> signOut() async {
    final user = _client.auth.currentUser;
    if (user != null) {
      try {
        await _recordEvent('sign_out', user);
      } catch (_) {
        // A history write must not prevent the local session from ending.
      }
    }
    await _client.auth.signOut(scope: SignOutScope.local);
  }

  static Future<void> updateDisplayName(String displayName) async {
    final user = _client.auth.currentUser;
    if (user == null || displayName.trim().isEmpty) return;

    await _client
        .from('users')
        .update({'display_name': displayName.trim()})
        .eq('id', user.id);
  }

  static Future<void> _recordEvent(String eventType, User user) async {
    await _client.from('auth_history').insert({
      'user_id': user.id,
      'event_type': eventType,
      'email': user.email,
    });
  }
}
