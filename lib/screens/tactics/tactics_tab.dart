import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drink_provider.dart';
import '../../utils/constants.dart';

class TacticsTab extends StatefulWidget {
  const TacticsTab({super.key});

  @override
  State<TacticsTab> createState() => _TacticsTabState();
}

class _TacticsTabState extends State<TacticsTab> {
  String? _selectedContext;

  @override
  Widget build(BuildContext context) {
    final drinkProvider = Provider.of<DrinkProvider>(context);
    final mostCommonContext = drinkProvider.getMostCommonContext();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Evidence-Based Tactics'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryColor.withOpacity(0.1),
                    AppConstants.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppConstants.primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'About These Tactics',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'These strategies are ranked by effectiveness from peer-reviewed research. Different tactics work better in different contexts.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  if (mostCommonContext != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: AppConstants.secondaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You drink most at $mostCommonContext. Focus on tactics for this context.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Filter by Context',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildContextChip('All', null),
                  const SizedBox(width: 8),
                  ...AppConstants.contexts.map((context) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildContextChip(context, context),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tactics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._getFilteredTactics().map((tactic) {
              return _buildTacticCard(tactic);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContextChip(String label, String? context) {
    final isSelected = _selectedContext == context;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedContext = context;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppConstants.primaryColor
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTactics() {
    if (_selectedContext == null) {
      return AppConstants.tactics;
    }

    return AppConstants.tactics.where((tactic) {
      final contexts = tactic['contexts'] as List<String>;
      return contexts.contains('All') || contexts.contains(_selectedContext);
    }).toList();
  }

  Widget _buildTacticCard(Map<String, dynamic> tactic) {
    final effectiveness = tactic['effectiveness'] as String;
    Color effectivenessColor;

    switch (effectiveness) {
      case 'High':
        effectivenessColor = AppConstants.secondaryColor;
        break;
      case 'Medium':
        effectivenessColor = AppConstants.warningColor;
        break;
      default:
        effectivenessColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: effectivenessColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.check_circle,
            color: effectivenessColor,
          ),
        ),
        title: Text(
          tactic['name'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: effectivenessColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$effectiveness Effectiveness',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: effectivenessColor,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How it works:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tactic['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.science,
                            size: 16,
                            color: AppConstants.primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Research Evidence:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tactic['evidence'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Best for:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (tactic['contexts'] as List<String>).map((context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppConstants.secondaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        context,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.secondaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
