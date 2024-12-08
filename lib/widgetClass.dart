class WidgetData {
  final List<DayPrayerTimes> prayerTimes; // Holds prayer times for 7 days

  WidgetData(this.prayerTimes);

  // Factory constructor to create an instance from JSON
  WidgetData.fromJson(Map<String, dynamic> json)
      : prayerTimes = (json['prayerTimes'] as List)
      .map((day) => DayPrayerTimes.fromJson(day))
      .toList();

  // Converts the instance to JSON format
  Map<String, dynamic> toJson() => {
    'prayerTimes': prayerTimes.map((day) => day.toJson()).toList(),
  };

  // Method to get a string representation of WidgetData for debugging
  @override
  String toString() {
    return prayerTimes.map((day) {
      return '''
      Date: ${day.date}
      Fajr: Azan ${day.fajrAzan}, Iqama ${day.fajrIqama}
      Sunrise: ${day.sunrise}
      Dhuhr: Azan ${day.dhuhrAzan}, Iqama ${day.dhuhrIqama}
      Asr: Azan ${day.asrAzan}, Iqama ${day.asrIqama}
      Maghrib: Azan ${day.magribAzan}, Iqama ${day.magribIqama}
      Isha: Azan ${day.ishaAzan}, Iqama ${day.ishaIqama}
      ''';
    }).join('\n');
  }
}


class DayPrayerTimes {
  final String date;
  final String fajrAzan;
  final String fajrIqama;
  final String sunrise;
  final String dhuhrAzan;
  final String dhuhrIqama;
  final String asrAzan;
  final String asrIqama;
  final String magribAzan;
  final String magribIqama;
  final String ishaAzan;
  final String ishaIqama;

  DayPrayerTimes({
    required this.date,
    required this.fajrAzan,
    required this.fajrIqama,
    required this.sunrise,
    required this.dhuhrAzan,
    required this.dhuhrIqama,
    required this.asrAzan,
    required this.asrIqama,
    required this.magribAzan,
    required this.magribIqama,
    required this.ishaAzan,
    required this.ishaIqama,
  });

  // Factory constructor to create a DayPrayerTimes instance from JSON
  DayPrayerTimes.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        fajrAzan = json['fajrAzan'],
        fajrIqama = json['fajrIqama'],
        sunrise = json['sunrise'],
        dhuhrAzan = json['dhuhrAzan'],
        dhuhrIqama = json['dhuhrIqama'],
        asrAzan = json['asrAzan'],
        asrIqama = json['asrIqama'],
        magribAzan = json['magribAzan'],
        magribIqama = json['magribIqama'],
        ishaAzan = json['ishaAzan'],
        ishaIqama = json['ishaIqama'];

  // Converts the DayPrayerTimes instance to JSON
  Map<String, dynamic> toJson() => {
    'date': date,
    'fajrAzan': fajrAzan,
    'fajrIqama': fajrIqama,
    'sunrise': sunrise,
    'dhuhrAzan': dhuhrAzan,
    'dhuhrIqama': dhuhrIqama,
    'asrAzan': asrAzan,
    'asrIqama': asrIqama,
    'magribAzan': magribAzan,
    'magribIqama': magribIqama,
    'ishaAzan': ishaAzan,
    'ishaIqama': ishaIqama,
  };

}
