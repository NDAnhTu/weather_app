import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_2/model/tram.dart';

class Tram_1_Service {
  static const String url =
      "https://testapp-54218-default-rtdb.firebaseio.com/tram/tram_1.json";
  static Future<List<Tram>> getTram_1() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        String dataa = "[${response.body}]";
        var data = jsonDecode(dataa);
        var parsed = List<Tram>.from(data.map((x) => Tram.fromJson(x)));
        return parsed;
      } else {
        print('loi');
        return <Tram>[];
      }
    } catch (e) {
      return <Tram>[];
    }
  }
}

class Tram_2_Service {
  static const String url =
      "https://testapp-54218-default-rtdb.firebaseio.com/tram/tram_2.json";

  static Future<List<Tram>> getTram_2() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        String dataa = "[${response.body}]";
        var data = jsonDecode(dataa);
        var parsed = List<Tram>.from(data.map((x) => Tram.fromJson(x)));
        return parsed;
      } else {
        print('loi');
        return <Tram>[];
      }
    } catch (e) {
      return <Tram>[];
    }
  }
}

class Tram_3_Service {
  static const String url =
      "https://testapp-54218-default-rtdb.firebaseio.com/tram/tram_3.json";

  static Future<List<Tram>> getTram_3() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        String dataa = "[${response.body}]";
        var data = jsonDecode(dataa);
        var parsed = List<Tram>.from(data.map((x) => Tram.fromJson(x)));
        return parsed;
      } else {
        print('loi');
        return <Tram>[];
      }
    } catch (e) {
      return <Tram>[];
    }
  }
}
