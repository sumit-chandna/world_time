import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class WorldTime {
  late String location;
  late String time;
  late String flag;
  late String url;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> fetchTime() async {
    try {
      final http.Response response = await http
          .get(Uri.http('worldtimeapi.org', '/api/timezone/$url', {}));
      final Map data = convert.jsonDecode(response.body);
      final String dateTime = data["datetime"];
      final int offset = int.parse(data["utc_offset"].substring(1, 3));
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: offset));
      time = intl.DateFormat.jm().format(now);
    } catch (e) {
      print("$e");
      time = "Could not get time data";
    }
  }
}

WorldTime instance =
    WorldTime(location: 'Berlin', flag: 'germany.png', url: 'Europe/Berlin');
