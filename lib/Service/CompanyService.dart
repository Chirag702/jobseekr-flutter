import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyService {
  Future<List<Map<String, dynamic>>?> getAllCompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    final response = await http.get(
      Uri.parse("https://api2.jobseekr.in/api/companies"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> companies =
          responseData.cast<Map<String, dynamic>>().toList();

      print('Companies: $companies');
      return companies;
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>>? getcompanyByIdCompanies(int i) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = (prefs.getString('token'))!.replaceAll(" ", "");

      final response = await http.get(
        Uri.parse("https://api2.jobseekr.in/api/companies/$i"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
      }
    } catch (ex) {
      print(ex);
      return {};
    }
  }
}
