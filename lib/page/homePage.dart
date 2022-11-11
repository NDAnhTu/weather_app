// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:test_2/map/curentLocation.dart';
import 'package:test_2/map/map.dart';
import 'package:test_2/model/tram.dart';
import 'package:test_2/notification/notificationservice.dart';
import 'package:test_2/service/tramService.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationApi = NotificationService();
  int _select = 1;
  late Timer _timer;
  int _start = 1;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            if (_select == 1) {
              getData_tram1();
            } else if (_select == 2) {
              getData_tram2();
            } else if (_select == 3) {
              getData_tram3();
            }
            _start = 1;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  late Timer timer;
  late List<Tram> _tram = [];
  late bool _loading = true;
  late int _mua_1 = 0, _mua_2 = 0, _mua_3 = 0;
  late String _name_mua = '';

  @override
  void initState() {
    startTimer();
    super.initState();
    tz.initializeTimeZones();
    notificationApi.initNotification(initSchedule: true);
    Tram_1_Service.getTram_1().then((tram1) {
      setState(() {
        _tram = tram1;
        _mua_1 = _tram[0].mua;
        _mua_1 == 1 ? _name_mua = _tram[0].name : null;
        notificationApi.sheduledNotification(
          'Thời tiết bên ngoài thế nào?',
          'Nhiệt độ: ${_tram[0].nhietdo}°C, Độ ẩm: ${_tram[0].doam}%',
          DateTime.now().add(
            Duration(seconds: 10),
          ),
        );
        Tram_2_Service.getTram_2().then((tram2) {
          setState(() {
            _tram = tram2;
            _mua_2 = _tram[0].mua;
            _mua_2 == 1 ? _name_mua = _tram[0].name : null;
            Tram_3_Service.getTram_3().then((tram3) {
              setState(() {
                _tram = tram3;
                _mua_3 = _tram[0].mua;
                _mua_3 == 1 ? _name_mua = _tram[0].name : null;
                if (_mua_1 == 1 && _mua_2 == 0 && _mua_3 == 0) {
                  _sendNoti();
                } else if (_mua_1 == 0 && _mua_2 == 1 && _mua_3 == 0) {
                  _sendNoti();
                } else if (_mua_1 == 0 && _mua_2 == 0 && _mua_3 == 1) {
                  _sendNoti();
                } else if (_mua_1 == 1 && _mua_2 == 1 && _mua_3 == 0) {
                  _sendNoti_2();
                } else if (_mua_1 == 1 && _mua_2 == 0 && _mua_3 == 1) {
                  _sendNoti_2();
                } else if (_mua_1 == 0 && _mua_2 == 1 && _mua_3 == 1) {
                  _sendNoti_2();
                } else if (_mua_1 == 1 && _mua_2 == 1 && _mua_3 == 1) {
                  _sendNotiAll();
                }
              });
            });
          });
        });
      });
    });
  }

  // ignore: non_constant_identifier_names
  getData_tram1() {
    Tram_1_Service.getTram_1().then((value) {
      setState(() {
        _tram = value;
        _loading = false;
        startTimer();
      });
    });
  }

  // ignore: non_constant_identifier_names
  getData_tram2() {
    Tram_2_Service.getTram_2().then((value) {
      setState(() {
        _tram = value;
        _loading = false;
        startTimer();
      });
    });
  }

  // ignore: non_constant_identifier_names
  getData_tram3() {
    Tram_3_Service.getTram_3().then((value) {
      setState(() {
        _tram = value;
        _loading = false;
        startTimer();
      });
    });
  }

  _sendNoti() {
    notificationApi.sendNoti(
      "Nếu bạn định ra ngoài",
      "Thời tiết tại ${_name_mua} đang có mưa!",
    );
  }

  _sendNoti_2() {
    notificationApi.sendNoti(
      "Nếu bạn định ra ngoài",
      "Thời tiết tại 2 nơi đang có mưa!",
    );
  }

  _sendNotiAll() {
    notificationApi.sendNoti(
      "Nếu bạn định ra ngoài",
      "Thời tiết cả 3 nơi đang có mưa!",
    );
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.short_text,
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Weather Forecast',
          style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                _loading
                    ? 'assets/gif/sun_1.json'
                    : _tram[0].mua == 0
                        ? 'assets/gif/sun_1.json'
                        : 'assets/gif/rain_1.json',
                width: _w / 1,
                height: _h / 7,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  _loading ? "...°" : "${_tram[0].nhietdo.toString()}°",
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.black),
                ),
              ),
              Text(
                _loading ? "..." : "${_tram[0].name.toString()}",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 61, 58, 58),
                ),
              ),
              SizedBox(
                width: 270,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        _select = 1;
                      },
                      child: _select == 1
                          ? Text(
                              'Home',
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            )
                          : Text(
                              'Home',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17, color: Colors.grey),
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        _select = 2;
                      },
                      child: _select == 2
                          ? Text(
                              'School',
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            )
                          : Text(
                              'School',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17, color: Colors.grey),
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        _select = 3;
                      },
                      child: _select == 3
                          ? Text(
                              'Company',
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            )
                          : Text(
                              'Company',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17, color: Colors.grey),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: _w / 3.7,
                      height: _h / 4.5,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0.8, 1),
                          colors: <Color>[
                            Color.fromARGB(255, 230, 148, 107),
                            Color.fromARGB(255, 187, 57, 111),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Temp',
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          Lottie.asset('assets/gif/temp.json',
                              width: _w / 1, height: _h / 10),
                          Text(
                            _loading
                                ? "...°"
                                : "${_tram[0].nhietdo.toString()}°",
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _w / 3.7,
                      height: _h / 4.5,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0.8, 1),
                          colors: <Color>[
                            Color.fromARGB(255, 77, 211, 189),
                            Color.fromARGB(255, 58, 196, 81),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Humi',
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          Lottie.asset('assets/gif/humi.json',
                              width: _w / 1, height: _h / 9),
                          Text(
                            _loading ? "...%" : "${_tram[0].doam.toString()}%",
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _w / 3.7,
                      height: _h / 4.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0.8, 1),
                          // ignore: prefer_const_literals_to_create_immutables
                          colors: <Color>[
                            Color.fromARGB(255, 247, 250, 97),
                            Color.fromARGB(255, 219, 69, 58),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Rain',
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          Lottie.asset('assets/gif/rain.json',
                              width: _w / 1, height: _h / 9),
                          Text(
                            _loading
                                ? "..."
                                : _tram[0].mua.toString() == "1"
                                    ? "Yes"
                                    : "No",
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _h / 80,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(MapPage(
                            mua_1: _mua_1, mua_2: _mua_2, mua_3: _mua_3));
                      },
                      child: Container(
                        width: _w / 1,
                        height: _h / 3.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: CurrentLocationScreen(
                            mua_1: _mua_1, mua_2: _mua_2, mua_3: _mua_3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
