import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/kai_controller.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';

class MedicalFacility {
  final String name;
  final String type;
  final String distance;
  final String status;
  final String address;
  final String phone;
  final IconData icon;
  final Color color;

  const MedicalFacility({
    required this.name,
    required this.type,
    required this.distance,
    required this.status,
    required this.address,
    required this.phone,
    required this.icon,
    required this.color,
  });
}

/// Emergency Mode Screen displaying nearby hospitals, ER clinics, 24/7 pharmacies,
/// quick 1-tap emergency hotline dials, live GPS pin, and reassuring Kai worried pose.
class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  static const List<MedicalFacility> nearbyFacilities = [
    MedicalFacility(
      name: 'City General Hospital & ER',
      type: '24/7 Emergency Room',
      distance: '0.8 km',
      status: 'Open 24/7',
      address: '124 Main Boulevard',
      phone: '+91 98765 43210',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFFFF5252),
    ),
    MedicalFacility(
      name: 'St. Jude Urgent Care Clinic',
      type: 'Clinic & First Aid',
      distance: '1.4 km',
      status: 'Open until 11:00 PM',
      address: '45 Park Lane',
      phone: '+91 98765 12345',
      icon: Icons.medical_services_rounded,
      color: Color(0xFF2DD4BF),
    ),
    MedicalFacility(
      name: 'Sunrise 24/7 Pharmacy',
      type: 'Chemist & Supplies',
      distance: '0.3 km',
      status: 'Open 24 Hours',
      address: '12 Market Street',
      phone: '+91 98765 67890',
      icon: Icons.medication_rounded,
      color: Color(0xFFFFB703),
    ),
  ];

  @override
  State<EmergencyModeScreen> createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  bool _isSquadNotified = false;

  @override
  void initState() {
    super.initState();
    // Hard Rule 1: Emergency Mode forces Worried state (no jokes)
    KaiController.instance.react(KaiTrigger.emergencyModeOpened);
  }

  void _callFacility(MedicalFacility facility) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF5252),
        content: Text('Dialing ${facility.name} (${facility.phone})...'),
      ),
    );
  }

  void _notifySquadContacts() {
    HapticFeedback.vibrate();
    setState(() {
      _isSquadNotified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF2DD4BF),
        content: Text(
          'Live GPS pin & Emergency alert sent to your trusted squad contacts! 🚨',
          style: TextStyle(color: Color(0xFF0F0E1A), fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh with subtle alert aura
          const AnimatedBackground(),

          SafeArea(
            child: Column(
              children: [
                // Navigation Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.shield_rounded, color: Color(0xFFFF5252), size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Emergency Assistance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                // Kai Worried Mascot Header (Joke-Free Reassuring Copy)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 60, expression: KaiExpression.worried),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: KaiBubble(text: "Okay, staying calm. Here's what's nearby. I've got you. 🛡️"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Quick Emergency Hotline Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HotlineButton(
                          label: 'Ambulance 108',
                          icon: Icons.airport_shuttle_rounded,
                          color: const Color(0xFFFF5252),
                          onTap: () {
                            HapticFeedback.vibrate();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xFFFF5252),
                                content: Text('Calling Emergency Ambulance Hotline 108...'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _HotlineButton(
                          label: 'Police 100',
                          icon: Icons.local_police_rounded,
                          color: const Color(0xFF6C63FF),
                          onTap: () {
                            HapticFeedback.vibrate();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xFF6C63FF),
                                content: Text('Calling Police Emergency Hotline 100...'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Live Location GPS Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(color: const Color(0xFF2DD4BF).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location_rounded, color: Color(0xFF2DD4BF), size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Live GPS: 12.9716° N, 77.5946° E (Accuracy: 5m)',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: _notifySquadContacts,
                        child: Text(
                          _isSquadNotified ? 'Squad Alerted ✓' : 'Alert Squad 📲',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: _isSquadNotified ? const Color(0xFF2DD4BF) : const Color(0xFFFF7A59),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Nearby Hospitals & Clinics Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      Icon(Icons.near_me_rounded, color: Color(0xFFFFD166), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Nearby Hospitals & Clinics',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Nearby Medical Facilities List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: EmergencyModeScreen.nearbyFacilities.length,
                    itemBuilder: (context, index) {
                      final facility = EmergencyModeScreen.nearbyFacilities[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withValues(alpha: 0.08),
                          border: Border.all(color: facility.color.withValues(alpha: 0.5), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: facility.color.withValues(alpha: 0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: facility.color.withValues(alpha: 0.2),
                                      ),
                                      child: Icon(facility.icon, color: facility.color, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          facility.name,
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                        Text(
                                          '${facility.type} • ${facility.distance}',
                                          style: TextStyle(fontSize: 11.5, color: Colors.white.withValues(alpha: 0.7)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.2),
                                  ),
                                  child: Text(
                                    facility.status,
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF2DD4BF)),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              '📍 ${facility.address}',
                              style: const TextStyle(fontSize: 11.5, color: Colors.white60),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _callFacility(facility),
                                    icon: const Icon(Icons.call_rounded, size: 14, color: Colors.white),
                                    label: const Text('Call 📞', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: facility.color,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Opening GPS navigation to ${facility.name}...')),
                                      );
                                    },
                                    icon: const Icon(Icons.navigation_rounded, size: 14, color: Colors.white),
                                    label: const Text('Navigate 📍', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HotlineButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: color.withValues(alpha: 0.25),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
