// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrayerTime {
  Date date;
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String imsak;
  String midnight;

  int fajrHour;
  int fajrMinute;
  int dhuhrHour;
  int dhuhrMinute;
  int asrHour;
  int asrMinute;
  int maghribHour;
  int maghribMinute;
  int ishaHour;
  int ishaMinute;
  PrayerTime({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.fajrHour,
    required this.fajrMinute,
    required this.dhuhrHour,
    required this.dhuhrMinute,
    required this.asrHour,
    required this.asrMinute,
    required this.maghribHour,
    required this.maghribMinute,
    required this.ishaHour,
    required this.ishaMinute,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    // Prayer int Values
    String time = '05:16 (EET)';
    String hour = time.substring(0, 2);
    String minute = time.substring(3, 5);
    int hourInt = int.parse(hour);
    return PrayerTime(
      date: Date.fromJson(json['date']),
      fajr: json['timings']['Fajr'],
      sunrise: json['timings']['Sunrise'],
      dhuhr: json['timings']['Dhuhr'],
      asr: json['timings']['Asr'],
      sunset: json['timings']['Sunset'],
      maghrib: json['timings']['Maghrib'],
      isha: json['timings']['Isha'],
      imsak: json['timings']['Imsak'],
      midnight: json['timings']['Midnight'],
      fajrHour: int.parse(json['timings']['Fajr'].toString().substring(0, 2)),
      fajrMinute: int.parse(json['timings']['Fajr'].toString().substring(3, 5)),
      dhuhrHour: int.parse(json['timings']['Dhuhr'].toString().substring(0, 2)),
      dhuhrMinute:
          int.parse(json['timings']['Dhuhr'].toString().substring(3, 5)),
      asrHour: int.parse(json['timings']['Asr'].toString().substring(0, 2)),
      asrMinute: int.parse(json['timings']['Asr'].toString().substring(3, 5)),
      maghribHour:
          int.parse(json['timings']['Maghrib'].toString().substring(0, 2)),
      maghribMinute:
          int.parse(json['timings']['Maghrib'].toString().substring(3, 5)),
      ishaHour: int.parse(json['timings']['Isha'].toString().substring(0, 2)),
      ishaMinute: int.parse(json['timings']['Isha'].toString().substring(3, 5)),
    );
  }
}

class Date {
  int timestamp;
  String readable;
  String date;
  int day;
  int month;
  int year;
  Date({
    required this.timestamp,
    required this.readable,
    required this.date,
    required this.day,
    required this.month,
    required this.year,
  });


  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      readable: json['readable'],
      date: json['gregorian']['date'],
      day: int.tryParse(json['gregorian']['day'].toString()) ?? 1,
      month: int.tryParse(json['gregorian']['month']['number'].toString()) ?? 1,
      year: int.tryParse(json['gregorian']['year'].toString()) ?? 1,
      timestamp: int.tryParse(json['timestamp'].toString()) ?? 1,
    );
  }
}
