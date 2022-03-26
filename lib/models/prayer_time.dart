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
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.date,
    this.asrHour,
    this.asrMinute,
    this.dhuhrHour,
    this.dhuhrMinute,
    this.ishaHour,
    this.ishaMinute,
    this.maghribHour,
    this.maghribMinute,
    this.fajrHour,
    this.fajrMinute,
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
    this.readable,
    this.date,
    this.day,
    this.month,
    this.year,
    this.timestamp,
  });

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      readable: json['readable'],
      date: json['gregorian']['date'],
      day: int.tryParse(json['gregorian']['day'].toString()),
      month: int.tryParse(json['gregorian']['month']['number'].toString()),
      year: int.tryParse(json['gregorian']['year'].toString()),
      timestamp: int.tryParse(json['timestamp'].toString())
    );
  }
}
