import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:muslim_dialy_guide/models/praying_time.dart';
import 'package:muslim_dialy_guide/providers/locationProvider.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:muslim_dialy_guide/widgets/praying_time/praying_time_container.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../exceptions.dart/location_exception.dart';

class PrayingTime extends StatefulWidget {
  static const String routeName = 'prayingTime';

  @override
  _PrayingTimeState createState() => _PrayingTimeState();
}

class _PrayingTimeState extends State<PrayingTime> {
  bool isLoading = false;
  /*-----------------------------------------------------------------------------------------------*/
  /*-------------------------------- praying photos list  -----------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  List<String> photos = [
    "assets/praying_time/subuh.png",
    "assets/praying_time/sunrise.png",
    "assets/praying_time/zhur.png",
    "assets/praying_time/asr.png",
    "assets/praying_time/sunset.png",
    "assets/praying_time/magrib.png",
    "assets/praying_time/isyah.png",
  ];

  List<String> _prayerTimes = [];
  List<String> _prayerNames = [];
  // String address = "Cairo, Egypt";

  /*-----------------------------------------------------------------------------------------------*/
  /*-------------------------------- get prayer times  -----------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> getPrayerTimes() async {
    setState(() {
      isLoading = true;
    });
    PrayerTime prayers = PrayerTime();

    prayers.setTimeFormat(prayers.getTime12());
    prayers.setCalcMethod(prayers.getEgypt());
    prayers.setAsrJuristic(prayers.getHanafi());
    prayers.setAdjustHighLats(prayers.getAdjustHighLats());

    List<int> offsets = [
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ]; // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha}
    prayers.tune(offsets);

    var currentTime = DateTime.now();

    final latLng = await getLocation();

    if (latLng != null) {
      setState(() {
        _prayerTimes = prayers.getPrayerTimes(
          currentTime,
          latLng.latitude,
          latLng.longitude,
          Constants.timeZone, // TODO: Fix this
        );
        _prayerNames = prayers.getTimeNames();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<LatLng> getLocation() async {
    try {
      final locationData =
          Provider.of<LocationProvider>(context, listen: false);
      await locationData.checkLocationPermissions();
      LocationData position = await locationData.getLocationData();

      print(position.longitude);
      print(position.latitude);

      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      } else {
        return null;
      }
    } on LocationException {
      // Handle Service/Permission Exception here
      // SharedWidgets.showToastMsg(e.msg, true);
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        title: "مواقيت الصلاة",
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: _prayerTimes.isEmpty
                      ? Center(
                          child: Text(
                            'لم يستطع التقاط موقعك برجاء التأكد من تشغيل ال GPS و إعادة المحاولة',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _prayerNames.length,
                          itemBuilder: (BuildContext context, position) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: PrayingTimeContainer(
                                  icon: photos[position],
                                  title: _prayerNames[position],
                                  time: _prayerTimes[position],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
    );
  }
}
