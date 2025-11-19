import 'dart:math';

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
}
