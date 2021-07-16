import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spin;
import 'package:get_it/get_it.dart';
import 'package:world_time/dto/world_time.dart';
import 'package:world_time/services/world_time_service.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  GetIt _getIt = GetIt.instance;

  void setupWorldTime() async {
    WorldTimeService wts = _getIt.get<WorldTimeService>();
    WorldTime instance = wts.getInitialLocation();
    await wts.fetchTime(instance);
    await wts.fetchTimezones();
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      "location": instance.location,
      "flag": instance.flag,
      "time": instance.time,
      "isDayTime": instance.isDayTime
    });
  }

  @override
  void initState() {
    super.initState();
    _getIt.registerSingleton<WorldTimeService>(WorldTimeService());
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Center(
          child: spin.SpinKitFadingCube(
            color: Colors.white,
            size: 80.0,
          ),
        ),
      ),
    );
  }
}
