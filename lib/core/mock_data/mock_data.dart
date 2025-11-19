import 'dart:math';

import 'package:flutter/material.dart';

class MockData {
  static final userProfile = {
    'id': 'user-1',
    'name': 'Aisha Noor',
    'age': 29,
    'gender': 'female',
    'heightCm': 168,
    'weightKg': 62,
    'chronicConditions': ['Asthma'],
  };

  static final vitals = [
    {
      'type': 'Heart rate',
      'value': 72,
      'unit': 'bpm',
      'min': 60,
      'max': 100,
      'score': 8.4,
    },
    {
      'type': 'Blood pressure',
      'value': '118/76',
      'unit': 'mmHg',
      'min': '90/60',
      'max': '120/80',
      'score': 7.6,
    },
    {
      'type': 'SpO₂',
      'value': 97,
      'unit': '%',
      'min': 95,
      'max': 100,
      'score': 9.1,
    },
    {
      'type': 'Blood sugar',
      'value': 93,
      'unit': 'mg/dL',
      'min': 80,
      'max': 120,
      'score': 7.9,
    },
  ];

  static List<Map<String, dynamic>> pagedCatalog(int page) {
    final random = Random(page);
    return List.generate(6, (index) {
      final score = random.nextDouble() * 4 + 6;
      return {
        'id': 'catalog-${page}_$index',
        'title': 'Care Device ${page * 6 + index + 1}',
        'category': index % 2 == 0 ? 'device' : 'tip',
        'tags': ['cardio', if (index.isEven) 'general'],
        'shortInfo': 'Portable sensor with smart reminders.',
        'longInfo':
            'Tracks vitals continuously and syncs to your cloud diary. Includes AI nudges.',
        'mainImageUrl': 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528',
        'score': score,
        'vitalType': 'heart_rate',
        'isFavorite': false,
      };
    });
  }

  static List<Map<String, dynamic>> pagedReports(int page) {
    return List.generate(4, (index) {
      final value = (6 + page) + index * .2;
      return {
        'id': 'report-${page}_$index',
        'score': value,
        'status': value > 7
            ? 'Normal'
            : value > 5
                ? 'Mild concern'
                : 'High risk',
        'summary': 'Week ${(page * 4) + index + 1} summary with trends.',
        'aiSummary': 'AI suggests daily walks and hydration.',
        'date': DateTime.now().subtract(Duration(days: page * 7 + index * 2)),
      };
    });
  }

  static List<Map<String, dynamic>> historicalVitals(String vital, int page) {
    return List.generate(5, (index) {
      final day = DateTime.now().subtract(Duration(days: page * 5 + index));
      return {
        'date': day,
        'value': 60 + (index * 5) + page,
        'trend': index.isEven ? 'up' : 'down',
      };
    });
  }

  static List<Map<String, dynamic>> wellnessInsights([int seed = 0]) {
    final random = Random(seed + 11);
    final palettes = [
      0xFF71E5A1,
      0xFF7AD7F0,
      0xFFFFD65A,
      0xFFFF6B6B,
    ];
    final templates = [
      {
        'id': 'insight-hydration',
        'title': 'Hydration rhythm',
        'summary': 'Your hydration stayed balanced for 48h and boosted focus.',
        'trend': 'up',
        'tags': ['hydration', 'focus'],
      },
      {
        'id': 'insight-sleep',
        'title': 'Sleep recovery',
        'summary': 'Deep sleep improved by 12 minutes last night.',
        'trend': 'steady',
        'tags': ['sleep', 'recovery'],
      },
      {
        'id': 'insight-activity',
        'title': 'Movement streak',
        'summary': 'You moved at least 6k steps three days in a row.',
        'trend': 'up',
        'tags': ['activity'],
      },
      {
        'id': 'insight-stress',
        'title': 'Calmer mornings',
        'summary': 'Heart-rate variability stabilized after mindful breathing.',
        'trend': 'down',
        'tags': ['stress', 'breath'],
      },
    ];
    return templates
        .map(
          (item) => {
            ...item,
            'impact': (6 + random.nextDouble() * 2).toStringAsFixed(1),
            'favorite': false,
            'color': Color(palettes[random.nextInt(palettes.length)]),
            'timeframe': '${12 + random.nextInt(12)}h',
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> journeyMilestones([int seed = 0]) {
    final random = Random(seed + 99);
    final titles = [
      'Breath training',
      'Morning sunlight',
      'Balanced meals',
      'Weekly report review',
    ];
    return List.generate(titles.length, (index) {
      return {
        'id': 'journey-$index',
        'title': titles[index],
        'description': 'Completed ${50 + random.nextInt(40)}% of this habit.',
        'progress': (.4 + random.nextDouble() * .5).clamp(0.0, 1.0),
        'date': DateTime.now().subtract(Duration(days: index * 2 + seed % 3)),
      };
    });
  }

  static List<Map<String, dynamic>> missionTimeline([int seed = 0]) {
    final random = Random(seed + 33);
    final missions = [
      'Stabilize circadian rhythm',
      'Prime hydration loops',
      'Layer mindful breaks',
      'Strengthen cardio base',
    ];
    return List.generate(missions.length, (index) {
      final progress = .35 + random.nextDouble() * .5;
      return {
        'id': 'mission-$index',
        'title': missions[index],
        'summary':
            'Focus window ${index + 1} with ${12 + index * 6}h runway remaining.',
        'progress': progress,
        'eta': '${random.nextInt(3) + 1}d',
        'status': progress > .8 ? 'ready' : 'in_progress',
        'color': Color(0xFF71E5A1 + index * 0x00111111),
      };
    });
  }

  static List<Map<String, dynamic>> missionPillars([int seed = 0]) {
    final random = Random(seed + 61);
    final items = [
      {
        'id': 'pillar-light',
        'title': 'Light + sleep',
        'subtitle': 'Morning light + deep sleep window',
      },
      {
        'id': 'pillar-hydration',
        'title': 'Hydration loops',
        'subtitle': '250ml every 90 minutes',
      },
      {
        'id': 'pillar-movement',
        'title': 'Micro movement',
        'subtitle': 'Mobility snacks & steps',
      },
      {
        'id': 'pillar-breath',
        'title': 'Breath balance',
        'subtitle': 'Box breathing before focus blocks',
      },
    ];
    return items
        .map((pillar) => {
              ...pillar,
              'active': random.nextBool(),
            })
        .toList();
  }

  static List<Map<String, dynamic>> missionRituals([int seed = 0]) {
    final random = Random(seed + 101);
    final rituals = [
      '2 min breath holds',
      'Protein-rich breakfast',
      'Afternoon sunlight walk',
      'Evening blue-light break',
      'Mobility before desk work',
    ];
    return List.generate(rituals.length, (index) {
      return {
        'id': 'ritual-$index',
        'title': rituals[index],
        'duration': '${5 + random.nextInt(6)} min',
        'completed': random.nextBool() && index.isEven,
      };
    });
  }

  static List<Map<String, dynamic>> companionPrompts([int seed = 0]) {
    final prompts = [
      {
        'id': 'prompt-energy',
        'label': 'Energy check',
        'body': 'How can I keep my energy steady this afternoon?',
      },
      {
        'id': 'prompt-focus',
        'label': 'Focus stack',
        'body': 'Suggest a focus ritual for my next deep-work block.',
      },
      {
        'id': 'prompt-sleep',
        'label': 'Sleep prep',
        'body': 'What should I log before bed to improve sleep score?',
      },
      {
        'id': 'prompt-recovery',
        'label': 'Recovery boost',
        'body': 'Recommend a quick recovery combo for tonight.',
      },
    ];
    final random = Random(seed + 7);
    return prompts
        .map((prompt) => {
              ...prompt,
              'emoji': ['⚡️', '🎯', '🌙', '🌊'][random.nextInt(4)],
            })
        .toList();
  }

  static String initialCompanionGreeting([int seed = 0]) {
    final greetings = [
      'Great job stabilizing hydration the last 24h. Ready for a deeper scan?',
      'Your HRV uptick shows calmer mornings. Want a breathing stack?',
      'Movement streak detected. I can layer a recovery combo if you\'d like.',
    ];
    final random = Random(seed + 3);
    return greetings[random.nextInt(greetings.length)];
  }

  static String generateCompanionReply(String topic, int seed) {
    final random = Random(seed + topic.length);
    final anchors = [
      'Pair a light stretch with 4-6 breathing before ${topic.toLowerCase()}.',
      'Log a quick reflection in Mission Control so I can adapt your cues.',
      'Stack a 250ml sip + daylight break; it stabilizes your focus arc.',
      'Consider a gentle mobility snack; it keeps recovery trending upward.',
    ];
    final closing = [
      'Ping me again after you complete it.',
      'I\'ll watch your vitals and nudge you if anything drifts.',
      'Save this as a ritual to surface it on the home mission cards.',
    ];
    return '${anchors[random.nextInt(anchors.length)]} '
        '${closing[random.nextInt(closing.length)]}';
  }

  static List<Map<String, dynamic>> coachPlan([int seed = 0]) {
    final steps = [
      {
        'id': 'plan-breath',
        'title': '2-min guided breathing',
        'detail': 'Slow inhales + extended exhale for nervous-system calm.',
        'duration': '2 min',
      },
      {
        'id': 'plan-walk',
        'title': '300m sunlight walk',
        'detail': 'Stack a short walk after breakfast for circadian boost.',
        'duration': '5 min',
      },
      {
        'id': 'plan-log',
        'title': 'Log gratitude note',
        'detail': 'Capture one positive observation in your journal.',
        'duration': '1 min',
      },
    ];
    final random = Random(seed + 7);
    return steps
        .map(
          (step) => {
            ...step,
            'completed': random.nextBool() && step['id'] != 'plan-log',
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> wellnessJourney([int seed = 0]) {
    final random = Random(seed + 33);
    final stories = [
      'Mindful wake up',
      'Precision hydration',
      'Movement snack',
      'Sleep sanctuary',
      'AI review',
    ];
    return List.generate(stories.length, (index) {
      return {
        'id': 'wellness-$index',
        'title': stories[index],
        'description':
            'Momentum ${(60 + random.nextInt(30))}%, keep the streak tonight.',
        'progress': (.35 + random.nextDouble() * .6).clamp(0.0, 1.0),
        'status': index.isEven ? 'steady' : 'boost',
        'time': '${random.nextInt(5) + 1}h ago',
      };
    });
  }

  static List<Map<String, dynamic>> mindfulnessSessions([int seed = 0]) {
    final sessions = [
      {
        'id': 'mind-breath',
        'title': 'Box breathing',
        'duration': '4 min',
        'focus': 'calm',
      },
      {
        'id': 'mind-focus',
        'title': 'Laser focus',
        'duration': '6 min',
        'focus': 'focused',
      },
      {
        'id': 'mind-energy',
        'title': 'Energy ramp',
        'duration': '3 min',
        'focus': 'energized',
      },
    ];
    final random = Random(seed + 55);
    return sessions
        .map((session) => {
              ...session,
              'completed': random.nextBool() && session['id'] == 'mind-breath',
              'image': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
            })
        .toList();
  }

  static List<Map<String, dynamic>> sleepCycles([int seed = 0]) {
    final random = Random(seed + 71);
    final labels = ['Wind down', 'Light sleep', 'Deep sleep', 'REM'];
    return List.generate(labels.length, (index) {
      final duration = 20 + random.nextInt(50);
      return {
        'id': 'sleep-$index',
        'stage': labels[index],
        'duration': duration,
        'score': (6.5 + random.nextDouble() * 3).toStringAsFixed(1),
        'highlight': index == 2
            ? 'Deep repair spike'
            : index == 3
                ? 'Creative dreams'
                : 'Ease into rest',
      };
    });
  }

  static List<Map<String, dynamic>> dailyBoosters([int seed = 0]) {
    final tasks = [
      {
        'id': 'boost-hydration',
        'title': 'Hydration pulse',
        'subtitle': '250ml water every 90 minutes.',
      },
      {
        'id': 'boost-break',
        'title': 'Mobility break',
        'subtitle': '3 squats + 1 stretch cycle.',
      },
      {
        'id': 'boost-sleep',
        'title': 'Night prep',
        'subtitle': 'Dim lights 30 min before bed.',
      },
    ];
    final random = Random(seed + 41);
    return tasks
        .map((task) => {
              ...task,
              'completed': random.nextBool() && task['id'] != 'boost-sleep',
            })
        .toList();
  }

  static List<Map<String, dynamic>> mealPlans(int seed) {
    final random = Random(seed + 13);
    final meals = [
      {
        'id': 'meal-breakfast',
        'title': 'Green focus smoothie',
        'time': '08:00',
        'calories': 320,
        'carbs': 42,
        'protein': 18,
        'fat': 12,
        'image': 'https://images.unsplash.com/photo-1543353071-873f17a7a088',
      },
      {
        'id': 'meal-lunch',
        'title': 'Rainbow bowl',
        'time': '13:00',
        'calories': 480,
        'carbs': 36,
        'protein': 30,
        'fat': 18,
        'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
      },
      {
        'id': 'meal-dinner',
        'title': 'Omega nourish plate',
        'time': '19:00',
        'calories': 510,
        'carbs': 28,
        'protein': 34,
        'fat': 22,
        'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
      },
    ];
    return meals
        .map(
          (meal) => {
            ...meal,
            'favorite': random.nextBool() && meal['id'] != 'meal-dinner',
            'calories': (meal['calories'] as int) + random.nextInt(60) - 20,
          },
        )
        .toList();
  }

  static Map<String, dynamic> macroBreakdown(int seed) {
    final random = Random(seed + 29);
    final carbs = 35 + random.nextInt(20);
    final protein = 25 + random.nextInt(15);
    final fat = 20 + random.nextInt(10);
    final fiber = 100 - carbs - protein - fat;
    return {
      'calories': 1800 + random.nextInt(350),
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'fiber': fiber.clamp(5, 30),
    };
  }

  static List<Map<String, dynamic>> snackIdeas(int seed) {
    final snacks = [
      {
        'id': 'snack-nuts',
        'title': 'Omega trail mix',
      },
      {
        'id': 'snack-tea',
        'title': 'Ginger focus tea',
      },
      {
        'id': 'snack-fruit',
        'title': 'Berry polyphenols',
      },
    ];
    final random = Random(seed + 5);
    return snacks
        .map(
          (snack) => {
            ...snack,
            'completed': random.nextBool() && snack['id'] == 'snack-fruit',
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> hydrationTimeline(int seed) {
    final random = Random(seed + 8);
    return List.generate(4, (index) {
      return {
        'id': 'hydration-$index',
        'time': '${8 + index * 3}:00',
        'amount': (.25 + random.nextDouble() * .2).toStringAsFixed(2),
        'mood': index.isEven ? 'focus' : 'calm',
      };
    });
  }

  static List<Map<String, dynamic>> hydrationReminders(int seed) {
    final titles = ['Morning glass', 'Midday refill', 'Evening wind down'];
    final random = Random(seed + 21);
    return List.generate(titles.length, (index) {
      return {
        'id': 'reminder-$index',
        'title': titles[index],
        'time': '${9 + index * 4}:30',
        'active': random.nextBool() || index == 0,
      };
    });
  }

  static List<Map<String, dynamic>> communityMoments(int seed) {
    final random = Random(seed + 44);
    final titles = [
      'Calm AM circle',
      'Movement accountability',
      'Sleep wind-down wins',
    ];
    return List.generate(titles.length, (index) {
      return {
        'id': 'moment-$index',
        'title': titles[index],
        'summary':
            'Members logged ${(40 + random.nextInt(40))}% habit adherence.',
        'time': '${index + 1}h ago',
        'claps': 20 + random.nextInt(60),
        'comments': 2 + random.nextInt(8),
        'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      };
    });
  }

  static List<Map<String, dynamic>> communityMentors(int seed) {
    final mentors = [
      {
        'id': 'mentor-1',
        'name': 'Dr. Lina',
        'role': 'Sleep coach',
        'avatar': 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
      },
      {
        'id': 'mentor-2',
        'name': 'Coach Tariq',
        'role': 'Breath mentor',
        'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
      },
      {
        'id': 'mentor-3',
        'name': 'Nura',
        'role': 'Nutritionist',
        'avatar': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      },
    ];
    final random = Random(seed + 63);
    return mentors
        .map((mentor) => {
              ...mentor,
              'streak': 12 + random.nextInt(8),
            })
        .toList();
  }

  static List<Map<String, dynamic>> communityCircles(int seed) {
    final random = Random(seed + 90);
    final titles = ['Evening breath circle', 'Weekend hike club'];
    return List.generate(titles.length, (index) {
      return {
        'id': 'circle-$index',
        'title': titles[index],
        'time': index == 0 ? 'Tonight 20:00' : 'Saturday 09:00',
        'joined': random.nextBool() && index == 0,
      };
    });
  }

  static List<Map<String, dynamic>> performanceSessions(int seed) {
    final random = Random(seed + 101);
    final titles = [
      'Mobility ladder',
      'Power walk burst',
      'Core pulse',
      'Neck reset',
    ];
    return List.generate(titles.length, (index) {
      return {
        'id': 'session-$index',
        'title': titles[index],
        'duration': '${4 + index * 2} min',
        'intensity': (random.nextInt(3) + 1) * 20,
        'completed': random.nextBool() && index != 2,
      };
    });
  }

  static List<Map<String, dynamic>> performanceTimeline(int seed) {
    final random = Random(seed + 202);
    final phases = [
      'Warm-up',
      'Mobility drill',
      'Stability focus',
      'Cool-down',
    ];
    return List.generate(phases.length, (index) {
      return {
        'id': 'timeline-$index',
        'title': phases[index],
        'detail': 'Quality ${(70 + random.nextInt(20))}%, keep cadence steady.',
        'expanded': index == 0,
      };
    });
  }

  static List<Map<String, dynamic>> mobilityHeat(int seed) {
    final random = Random(seed + 333);
    final zones = ['Neck', 'Shoulders', 'Spine', 'Hips', 'Ankles'];
    return List.generate(zones.length, (index) {
      return {
        'id': 'mobility-$index',
        'zone': zones[index],
        'score': (60 + random.nextInt(30)).toDouble(),
      };
    });
  }

  static List<Map<String, dynamic>> recoveryProtocols(int seed) {
    final random = Random(seed + 404);
    final steps = [
      'Resonant breathing',
      'Contrast shower',
      'Foam roll release',
      'Sleep sanctuary prep',
    ];
    return List.generate(steps.length, (index) {
      return {
        'id': 'recovery-$index',
        'title': steps[index],
        'description': 'Complete ${2 + index} cycles with calm exhale focus.',
        'completed': random.nextBool() && index.isEven,
      };
    });
  }

  static List<Map<String, dynamic>> recoveryMoments(int seed) {
    final random = Random(seed + 505);
    final titles = ['AM Reset', 'Midday pause', 'Evening unwind'];
    return List.generate(titles.length, (index) {
      return {
        'id': 'moment-reset-$index',
        'title': titles[index],
        'summary': '${5 + index * 2} min breath wave',
        'favorite': random.nextBool() && index == 2,
        'image': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      };
    });
  }

  static List<Map<String, dynamic>> breathStacks(int seed) {
    final random = Random(seed + 606);
    final stacks = [
      {'id': 'stack-box', 'title': 'Box 4-4-4-4'},
      {'id': 'stack-478', 'title': '4-7-8 reset'},
      {'id': 'stack-double', 'title': 'Double exhale'},
    ];
    return stacks
        .map(
          (stack) => {
            ...stack,
            'completed': random.nextBool() && stack['id'] != 'stack-double',
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> labOrders(int seed) {
    final random = Random(seed + 515);
    final tests = [
      {
        'title': 'Advanced blood panel',
        'type': 'blood',
        'location': 'Clinic hub',
        'prep': 'Fasting',
      },
      {
        'title': 'Genetics scan',
        'type': 'genetics',
        'location': 'Home kit',
        'prep': 'No prep',
      },
      {
        'title': 'Microbiome map',
        'type': 'microbiome',
        'location': 'Courier pickup',
        'prep': 'Hydrate',
      },
    ];
    return List.generate(tests.length, (index) {
      final test = tests[index];
      return {
        'id': 'lab-$index',
        'title': test['title'],
        'type': test['type'],
        'window': '${8 + index * 3}:00 - ${10 + index * 3}:30',
        'location': test['location'],
        'status': index == 0 ? 'Ready' : 'Queued',
        'preparation': test['prep'],
      };
    });
  }

  static List<Map<String, dynamic>> labResults(int seed) {
    final random = Random(seed + 616);
    final markers = [
      {'marker': 'Vitamin D', 'unit': 'ng/mL'},
      {'marker': 'Inflammation', 'unit': 'score'},
      {'marker': 'Microbiome diversity', 'unit': '%'},
    ];
    return List.generate(markers.length, (index) {
      final marker = markers[index];
      final value = 20 + random.nextInt(40);
      return {
        'id': 'result-$index',
        'marker': marker['marker'],
        'summary': 'Trend ${(random.nextBool() ? 'improving' : 'stable')}.',
        'value': value,
        'unit': marker['unit'],
        'status': index == 0 ? 'normal' : 'high',
        'acknowledged': index == 0,
      };
    });
  }

  static List<Map<String, dynamic>> labKits(int seed) {
    final random = Random(seed + 717);
    final kits = ['Blood kit', 'Genetics swab', 'Microbiome pack'];
    return List.generate(kits.length, (index) {
      return {
        'id': 'kit-$index',
        'title': kits[index],
        'status': index == 0 ? 'Delivered' : 'In transit',
        'progress': (.4 + random.nextDouble() * .5).clamp(0.0, 1.0),
        'completed': index == 0,
      };
    });
  }

  static List<Map<String, dynamic>> labTimeline(int seed) {
    final steps = [
      'Kit shipped',
      'Sample collected',
      'Lab processing',
      'Insights ready',
    ];
    final random = Random(seed + 818);
    return List.generate(steps.length, (index) {
      return {
        'id': 'timeline-lab-$index',
        'label': steps[index],
        'detail': index == 2
            ? 'Analyzing biomarkers'
            : 'Estimated ${(index + 1) * 6}h',
        'eta': '${index + 2}h',
        'completed': index < 2 || random.nextBool(),
      };
    });
  }

  static List<Map<String, dynamic>> careTeamMembers(int seed) {
    final members = [
      {
        'id': 'care-mentor-1',
        'name': 'Dr. Hadi',
        'role': 'Cardio guide',
        'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      },
      {
        'id': 'care-mentor-2',
        'name': 'Coach Salma',
        'role': 'Recovery mentor',
        'avatar': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      },
      {
        'id': 'care-mentor-3',
        'name': 'Nour',
        'role': 'Nutritionist',
        'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
      },
    ];
    final random = Random(seed + 919);
    return members
        .map((member) => {
              ...member,
              'favorite': random.nextBool() && member['id'] != 'care-mentor-3',
            })
        .toList();
  }

  static List<Map<String, dynamic>> careTickets(int seed) {
    final random = Random(seed + 2023);
    final tickets = [
      {
        'id': 'ticket-1',
        'title': 'Follow-up on lab plan',
        'channel': 'video',
      },
      {
        'id': 'ticket-2',
        'title': 'Breath coaching',
        'channel': 'chat',
      },
    ];
    return tickets
        .map((ticket) => {
              ...ticket,
              'status': ticket['id'] == 'ticket-1' ? 'open' : 'closed',
              'updated': '${random.nextInt(4) + 1}h ago',
              'eta': '${random.nextInt(2) + 1}h',
            })
        .toList();
  }

  static List<Map<String, dynamic>> carePlans(int seed) {
    final random = Random(seed + 3033);
    final steps = [
      'Upload latest labs',
      'Book hydration coach',
      'Share mindfulness log',
    ];
    return List.generate(steps.length, (index) {
      return {
        'id': 'care-plan-$index',
        'title': steps[index],
        'detail': '${index + 1} tap to complete',
        'completed': random.nextBool() && index == 0,
      };
    });
  }
}
