import 'supabase_service.dart';

class PreferenceService {
  /// Get the currently logged-in user's preferences.
  static Future<Map<String, dynamic>?> getPreferences() async {
    final user = SupabaseService.client.auth.currentUser;

    if (user == null) {
      throw Exception('No logged-in user.');
    }

    final data = await SupabaseService.client
        .from('preferences')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return data;
  }

  static Future<void> savePreferences({
    required int budget,
    required int travelDistance,
    required String transport,
    required String foodPreferences,
    required List<String> activities,
    String? mood,
    String? squad,
  }) async {
    final user = SupabaseService.client.auth.currentUser;

    if (user == null) {
      throw Exception('No logged-in user.');
    }

    final data = {
      'user_id': user.id,
      'budget': budget,
      'travel_distance': travelDistance,
      'transport': transport,
      'food_preferences': foodPreferences,
      'activity': activities,
      'mood': mood,
      'squad': squad,
    };

    await SupabaseService.client.from('preferences').upsert(data);
  }
}
