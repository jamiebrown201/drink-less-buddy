import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/services/haptic_service.dart';

class ResearchTabAnimated extends StatelessWidget {
  const ResearchTabAnimated({super.key});

  // Research citations
  final List<Map<String, String>> researchCitations = const [
    {
      'title': 'Self-Monitoring and Alcohol Reduction',
      'finding':
          'Self-monitoring alone can reduce alcohol consumption by 25%. It\'s the single strongest predictor of behavior change.',
      'source': 'Michie et al., Addiction Journal, 2012',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'title': 'Personalized Feedback Effectiveness',
      'finding':
          'Personalized normative feedback interventions reduce consumption by an average of 31% compared to control groups.',
      'source': 'Bertholet et al., Drug and Alcohol Dependence, 2015',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'title': 'Intention Setting and Behavior Change',
      'finding':
          'Implementation intentions ("If-Then" planning) increased goal achievement by 31-33% for health behaviors including alcohol moderation.',
      'source': 'Gollwitzer & Sheeran, Advances in Experimental Social Psychology, 2006',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Research & Evidence',
                        style: AppTheme.displayMedium,
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        'The science behind our approach',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  StaggeredList(
                    children: [
                      // Hero Card
                      AnimatedCard(
                        gradient: AppTheme.primaryGradient,
                        boxShadow: AppTheme.glowShadow(AppTheme.primaryBlue),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppTheme.spacing12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing16),
                            Text(
                              'Evidence-Based Approach',
                              style: AppTheme.headlineLarge.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Text(
                              'Every feature in Drink Less Buddy is based on peer-reviewed research and proven behavioral science principles.',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing24),

                      // Core Methods
                      Text('Core Methods', style: AppTheme.headlineLarge),
                      const SizedBox(height: AppTheme.spacing16),

                      _buildMethodCard(
                        'Self-Monitoring',
                        '85% Engagement Rate',
                        'Tracking your drinks is the single strongest predictor of behavior change. Self-monitoring alone can reduce consumption by 25%.',
                        Icons.track_changes,
                        AppTheme.secondaryGreen,
                      ),
                      const SizedBox(height: AppTheme.spacing12),

                      _buildMethodCard(
                        'Personalized Feedback',
                        '31% Average Reduction',
                        'Comparing your consumption to actual norms (not misconceptions) and showing patterns drives significant reduction in drinking.',
                        Icons.insights,
                        AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: AppTheme.spacing12),

                      _buildMethodCard(
                        'Prospective Planning',
                        '31-33% Reduction',
                        'Setting intentions for tomorrow (things you want to do hangover-free) reduces consumption tonight. Just-in-time planning is highly effective.',
                        Icons.event_note,
                        AppTheme.accentPurple,
                      ),
                      const SizedBox(height: AppTheme.spacing24),

                      // Key Research Findings
                      Text('Key Research Findings', style: AppTheme.headlineLarge),
                      const SizedBox(height: AppTheme.spacing16),

                      ...researchCitations.map((citation) => _buildCitationCard(citation, context)),

                      const SizedBox(height: AppTheme.spacing24),

                      // Important Note
                      AnimatedCard(
                        color: AppTheme.secondaryGreen.withOpacity(0.1),
                        border: Border.all(
                          color: AppTheme.secondaryGreen,
                          width: 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppTheme.spacing8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: AppTheme.secondaryGreen,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacing12),
                                Text('Important Note', style: AppTheme.titleMedium),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacing12),
                            Text(
                              'This app is designed for people who want to moderate their drinking, not for those with diagnosed alcohol dependence or Alcohol Use Disorder (AUD).',
                              style: AppTheme.bodyMedium.copyWith(height: 1.5),
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Text(
                              'If you\'re experiencing withdrawal symptoms, inability to stop drinking, or other signs of dependence, please consult a healthcare professional.',
                              style: AppTheme.bodyMedium.copyWith(
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(
    String title,
    String stat,
    String description,
    IconData icon,
    Color color,
  ) {
    return AnimatedCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.titleMedium),
                const SizedBox(height: AppTheme.spacing4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(
                    stat,
                    style: AppTheme.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  description,
                  style: AppTheme.bodyMedium.copyWith(
                    height: 1.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitationCard(Map<String, String> citation, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: AnimatedCard(
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              citation['title']!,
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              citation['finding']!,
              style: AppTheme.bodyMedium.copyWith(
                height: 1.5,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Source: ${citation['source']}',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            GestureDetector(
              onTap: () async {
                await HapticService.lightImpact();
                _launchURL(citation['url']!);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.link,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: AppTheme.spacing4),
                  Text(
                    'Read the research',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
