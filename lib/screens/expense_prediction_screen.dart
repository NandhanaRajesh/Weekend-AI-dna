import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'final_itinerary_screen.dart';

class ExpenseItem {
  final String title;
  final String cost;
  final IconData icon;
  final Color color;
  final bool isBuffer;
  final bool isExpandable;
  final List<String>? details;

  const ExpenseItem({
    required this.title,
    required this.cost,
    required this.icon,
    required this.color,
    this.isBuffer = false,
    this.isExpandable = false,
    this.details,
  });
}

/// Smart Expense Prediction Screen featuring torn paper receipt layout, itemized breakdown,
/// expandable hidden charges, min/expected/max range indicator dial, and Kai accountant commentary.
class ExpensePredictionScreen extends StatefulWidget {
  const ExpensePredictionScreen({super.key});

  static const List<ExpenseItem> items = [
    ExpenseItem(
      title: 'Fuel',
      cost: '₹350',
      icon: Icons.local_gas_station_rounded,
      color: Color(0xFFFF7A59),
    ),
    ExpenseItem(
      title: 'Toll Booths',
      cost: '₹120',
      icon: Icons.alt_route_rounded,
      color: Color(0xFF2DD4BF),
    ),
    ExpenseItem(
      title: 'Food & Drinks',
      cost: '₹900',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFFB703),
    ),
    ExpenseItem(
      title: 'Entry Tickets',
      cost: '₹300',
      icon: Icons.confirmation_number_rounded,
      color: Color(0xFF6C63FF),
    ),
    ExpenseItem(
      title: 'Hidden Charges',
      cost: '₹150',
      icon: Icons.search_rounded,
      color: Color(0xFFFF5252),
      isExpandable: true,
      details: [
        'Parking fee: ₹50',
        'Surprise entry fee: ₹40',
        'Overpriced souvenir: ₹60',
      ],
    ),
    ExpenseItem(
      title: 'Buffer (just in case)',
      cost: '₹250',
      icon: Icons.shield_rounded,
      color: Color(0xFF8B5CF6),
      isBuffer: true,
    ),
  ];

  @override
  State<ExpensePredictionScreen> createState() => _ExpensePredictionScreenState();
}

class _ExpensePredictionScreenState extends State<ExpensePredictionScreen> {
  String _kaiSpeechText = "I crunched the numbers, including the sneaky ones you always forget about. 🧮";
  bool _isHiddenChargesExpanded = false;

  void _toggleHiddenCharges() {
    HapticFeedback.lightImpact();
    setState(() {
      _isHiddenChargesExpanded = !_isHiddenChargesExpanded;
      _kaiSpeechText = "This is my professional estimate for 'stuff that always happens.' Trust the process. 🕵️";
    });
  }

  void _onContinue() {
    HapticFeedback.heavyImpact();
    setState(() {
      _kaiSpeechText = "Budget locked in. No refunds if you buy the overpriced souvenir anyway 🎟️";
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FinalItineraryScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: Column(
              children: [
                // Top App Bar
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
                      const Text(
                        'Smart Expense Breakdown',
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                // Kai Accountant Visor Header & Speech Bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 62, expression: KaiExpression.thinking),
                      const SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Main Receipt & Range Indicator Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Column(
                      children: [
                        // Torn Paper Scrapbook Receipt Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withValues(alpha: 0.1),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.22), width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                blurRadius: 16,
                                offset: Offset(0, 6),
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
                                    children: const [
                                      Icon(Icons.receipt_long_rounded, color: Color(0xFFFFD166), size: 20),
                                      SizedBox(width: 6),
                                      Text(
                                        'ESTIMATED RECEIPT',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFFFD166),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withValues(alpha: 0.12),
                                    ),
                                    child: const Text(
                                      '6 Items',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Itemized Line Items
                              ...ExpensePredictionScreen.items.map((item) {
                                if (item.isExpandable) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: _toggleHiddenCharges,
                                        child: _ExpenseLineRow(item: item, isExpanded: _isHiddenChargesExpanded),
                                      ),
                                      if (_isHiddenChargesExpanded && item.details != null)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 12, left: 24),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.redAccent.withValues(alpha: 0.15),
                                            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: item.details!.map((d) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2),
                                                child: Text(
                                                  '• $d',
                                                  style: const TextStyle(fontSize: 11.5, color: Colors.white70, fontWeight: FontWeight.w600),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                    ],
                                  );
                                }
                                return _ExpenseLineRow(item: item);
                              }),

                              const Divider(color: Colors.white24, height: 24, thickness: 1.2),

                              // Rubber-Stamped Total Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'EXPECTED TOTAL',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  // Stamp Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD166),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF0F0E1A), width: 2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x60000000),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Total: ₹2,070',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0F0E1A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Min / Expected / Max Range Indicator Dial Bar
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Predicted Spend Range:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2DD4BF),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Range Track Bar
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 12,
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: 0.72,
                                    child: Container(
                                      height: 12,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF2DD4BF), Color(0xFFFF7A59)],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Min ₹1,700', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white60)),
                                  Text('Expected ₹2,070 🎯', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFFFD166))),
                                  Text('Max ₹2,500', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white60)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button ("Looks Good, Continue")
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x60FF7A59),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Looks Good, Continue 🚀',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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

class _ExpenseLineRow extends StatelessWidget {
  final ExpenseItem item;
  final bool isExpanded;

  const _ExpenseLineRow({
    required this.item,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: item.isBuffer
            ? item.color.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: item.isBuffer ? item.color : Colors.white.withValues(alpha: 0.15),
          width: item.isBuffer ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 16, color: item.color),
              const SizedBox(width: 8),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: item.isBuffer ? FontWeight.w800 : FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (item.isExpandable) ...[
                const SizedBox(width: 6),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Colors.white60,
                ),
              ],
            ],
          ),
          Text(
            item.cost,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }
}
