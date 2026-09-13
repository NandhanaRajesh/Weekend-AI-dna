import 'supabase_service.dart';

class UserService {
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = SupabaseService.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await SupabaseService.client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data;
  }
}