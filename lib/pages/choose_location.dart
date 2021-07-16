import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:world_time/dto/world_time.dart';
import 'package:world_time/services/world_time_service.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  late WorldTimeService wts;

  _ChooseLocationState() {
    GetIt _getIt = GetIt.instance;
    wts = _getIt.get<WorldTimeService>();
  }

  @override
  void initState() {
    super.initState();
  }

  void updateTime(index) async {
    WorldTime instance = wts.locations[index];
    await wts.fetchTime(instance);
    Navigator.pop(context, {
      "location": instance.location,
      "flag": instance.flag,
      "time": instance.time,
      "isDayTime": instance.isDayTime
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text("Choose a Location"),
      ),
      body: ListView.builder(
        itemCount: wts.locations.length,
        itemBuilder: (context, index) {
          // String fileloc = "assets/${wts.locations[index].flag}";
          // bool fileExists =
          //     File("assets/${wts.locations[index].flag}").existsSync();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
            child: Card(
              child: ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: AssetImage(
                //       File("assets/${wts.locations[index].flag}").existsSync()
                //           ? "assets/${wts.locations[index].flag}"
                //           : "assets/uk.png"),
                // ),
                title: Text(wts.locations[index].location),
                onTap: () {
                  updateTime(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
