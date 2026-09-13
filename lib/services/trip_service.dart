import 'supabase_service.dart';

class TripService {
  static Future<String> savePlannerTrip({
    required int budget,
    required double travelDistanceKm,
    required String transport,
    required String mood,
    required String squad,
    required List<String> activities,
    required String foodPreferences,
  }) async {
    final client = SupabaseService.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No logged-in user.');

    final trip = await client
        .from('trips')
        .insert({
          'user_id': user.id,
          'title': 'Weekend plan',
          'mood': mood,
          'squad': squad,
          'budget': budget,
          'travel_distance_km': travelDistanceKm,
          'transport': transport,
          'itinerary': {
            'activities': activities,
            'food_preferences': foodPreferences,
          },
        })
        .select('id')
        .single();

    return trip['id'] as String;
  }
}
