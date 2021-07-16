import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:world_time/dto/world_time.dart';

class WorldTimeService {
  List<WorldTime> locations = [];

  WorldTime getInitialLocation() {
    return WorldTime(
        continent: "Europe",
        location: 'Berlin',
        flag: 'germany.png',
        url: 'Europe/Berlin');
  }

  Future<void> fetchTime(worldTime) async {
    try {
      final http.Response response = await http.get(
          Uri.http('worldtimeapi.org', '/api/timezone/${worldTime.url}', {}));
      final Map data = convert.jsonDecode(response.body);
      final String dateTime = data["datetime"];
      final int offset = int.parse(data["utc_offset"].substring(1, 3));

      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: offset));

      worldTime.isDayTime = now.hour > 6 && now.hour < 20 ? true : false;

      worldTime.time = intl.DateFormat.jm().format(now);
    } catch (e) {
      print("$e");
      worldTime.time = "Could not get time data";
    }
  }

  Future<void> fetchTimezones() async {
    try {
      final http.Response response =
          await http.get(Uri.http('worldtimeapi.org', '/api/timezone', {}));
      final List data = convert.jsonDecode(response.body);
      data.forEach((element) {
        List<String> parts = element.toString().split("/");
        try {
          locations.add(WorldTime(
              continent: parts[0],
              url: element,
              location: parts[parts.length - 1],
              flag: '${parts[parts.length - 1].toLowerCase()}.png'));
        } catch (e) {
          print(element);
        }
      });
      locations.sort((a, b) {
        return a.location.toLowerCase().compareTo(b.location.toLowerCase());
      });
    } catch (e) {
      print("$e");
    }
  }
}
