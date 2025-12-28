import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Drink Less Buddy';
  static const String appVersion = '1.0.0';

  // Colors
  static const Color primaryColor = Color(0xFF3B82F6); // Blue
  static const Color secondaryColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color dangerColor = Color(0xFFEF4444); // Red
  static const Color backgroundColor = Color(0xFFF9FAFB);

  // Supabase Configuration (replace with your actual values)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // UK Guidelines (units per week)
  static const double ukGuidelineUnitsPerWeek = 14.0;

  // Premium Features
  static const String premiumPriceMonthly = '£4.99';
  static const String premiumPriceYearly = '£49.99';

  // Standard Drink Units (UK)
  static const Map<String, double> standardUnits = {
    'Beer/Lager (Pint)': 2.3,
    'Beer/Lager (Half Pint)': 1.2,
    'Wine (Small Glass 125ml)': 1.5,
    'Wine (Medium Glass 175ml)': 2.1,
    'Wine (Large Glass 250ml)': 3.0,
    'Spirit (Single 25ml)': 1.0,
    'Spirit (Double 50ml)': 2.0,
    'Alcopop (275ml)': 1.5,
    'Cider (Pint)': 2.6,
    'Champagne (Glass)': 1.5,
    'Cocktail': 2.0,
  };

  // Moods for tracking
  static const List<String> moods = [
    'Happy',
    'Stressed',
    'Anxious',
    'Bored',
    'Celebratory',
    'Tired',
    'Social',
    'Relaxed',
  ];

  // Contexts for tracking
  static const List<String> contexts = [
    'Home',
    'Pub/Bar',
    'Restaurant',
    'Friend\'s House',
    'Party',
    'Work Event',
    'Outdoors',
    'Special Occasion',
  ];

  // Evidence-based tactics (ranked by effectiveness from research)
  static const List<Map<String, dynamic>> tactics = [
    {
      'id': '1',
      'name': 'Count Your Drinks',
      'effectiveness': 'High',
      'description':
          'Keep track of every drink you consume. Self-monitoring alone can reduce consumption by 25%.',
      'contexts': ['All'],
      'evidence': 'Self-monitoring is the strongest predictor of behavior change (85% engagement rate).',
    },
    {
      'id': '2',
      'name': 'Set a Limit Before You Start',
      'effectiveness': 'High',
      'description':
          'Decide on your maximum number of drinks before your first one. Pre-commitment increases adherence by 40%.',
      'contexts': ['All'],
      'evidence': 'Planning interventions show 31-33% reduction in consumption.',
    },
    {
      'id': '3',
      'name': 'Alternate with Water',
      'effectiveness': 'High',
      'description':
          'Have a glass of water or soft drink between alcoholic beverages. Reduces overall consumption and helps with hydration.',
      'contexts': ['Pub/Bar', 'Party', 'Restaurant'],
      'evidence': 'Pacing strategies reduce consumption by 20-30% in social contexts.',
    },
    {
      'id': '4',
      'name': 'Use a Smaller Glass',
      'effectiveness': 'Medium',
      'description':
          'Pour drinks into smaller glasses to reduce portion size without feeling deprived.',
      'contexts': ['Home'],
      'evidence': 'Environmental restructuring shows 15-20% reduction.',
    },
    {
      'id': '5',
      'name': 'Practice Saying No',
      'effectiveness': 'High',
      'description':
          'Prepare and rehearse polite ways to refuse drinks. "I\'m taking it easy tonight" or "I\'m driving".',
      'contexts': ['Work Event', 'Party', 'Pub/Bar'],
      'evidence': 'Refusal skills training increases success rates by 35%.',
    },
    {
      'id': '6',
      'name': 'Delay Your First Drink',
      'effectiveness': 'Medium',
      'description':
          'Wait at least 30 minutes after arriving before having your first drink. Reduces total consumption.',
      'contexts': ['Party', 'Restaurant', 'Pub/Bar'],
      'evidence': 'Delay tactics reduce consumption by 18-25%.',
    },
    {
      'id': '7',
      'name': 'Avoid High-Risk Situations',
      'effectiveness': 'High',
      'description':
          'Identify and avoid or limit time in situations where you typically drink heavily.',
      'contexts': ['All'],
      'evidence': 'Situational avoidance reduces consumption by 30-40%.',
    },
    {
      'id': '8',
      'name': 'Eat Before Drinking',
      'effectiveness': 'Medium',
      'description':
          'Have a proper meal before drinking to slow alcohol absorption and reduce desire to drink quickly.',
      'contexts': ['All'],
      'evidence': 'Food intake moderates consumption by 15-20%.',
    },
    {
      'id': '9',
      'name': 'Track Your Spending',
      'effectiveness': 'Medium',
      'description':
          'Monitor how much money you spend on alcohol. Financial awareness can motivate reduction.',
      'contexts': ['All'],
      'evidence': 'Financial tracking adds 10-15% motivation boost.',
    },
    {
      'id': '10',
      'name': 'Replace with Enjoyable Alternatives',
      'effectiveness': 'High',
      'description':
          'Find activities you enjoy that don\'t involve drinking. Exercise, hobbies, socializing without alcohol.',
      'contexts': ['Home', 'Outdoors'],
      'evidence': 'Behavioral substitution shows 25-35% sustained reduction.',
    },
  ];

  // Research citations
  static const List<Map<String, String>> researchCitations = [
    {
      'title': 'Self-monitoring effectiveness',
      'finding': '85% engagement rate, strongest predictor of behavior change',
      'source': 'Effectiveness of web-based personalised feedback interventions',
      'url': 'https://onlinelibrary.wiley.com/doi/10.1111/dar.13848',
    },
    {
      'title': 'Personalized feedback impact',
      'finding': '31-33% average reduction in alcohol consumption',
      'source': 'Web-based interventions meta-analysis',
      'url': 'https://pmc.ncbi.nlm.nih.gov/articles/PMC4160666/',
    },
    {
      'title': 'Context-specific tactics',
      'finding': 'Preferences vary by drinking context (home vs pub vs work)',
      'source': 'Cutting consumption without diluting the experience',
      'url': 'https://pmc.ncbi.nlm.nih.gov/articles/PMC11338454/',
    },
    {
      'title': 'Just-in-time planning',
      'finding': 'Mobile planning interventions reduce risky drinking episodes',
      'source': 'Assessment of mobile phone Just-in-Time Planning Intervention',
      'url': 'https://pmc.ncbi.nlm.nih.gov/articles/PMC7284414/',
    },
    {
      'title': 'Drink tracking app effectiveness',
      'finding': 'Self-monitoring via apps shows sustained reduction',
      'source': 'The development of Drink Less app',
      'url': 'https://pmc.ncbi.nlm.nih.gov/articles/PMC6417151/',
    },
  ];
}
