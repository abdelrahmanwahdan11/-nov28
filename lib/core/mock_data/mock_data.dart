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
}
