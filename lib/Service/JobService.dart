import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class JobService {
  Future<List<Map<String, dynamic>>?> getAllJobs() async {
    try {
      final response = await http.get(
        Uri.parse("https://api2.jobseekr.in/api/jobs"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> jobs =
            responseData.cast<Map<String, dynamic>>().toList();

        print('Jobs: $jobs');
        return jobs;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>>? getJobById(int i) async {
    try {
      final response = await http.get(
        Uri.parse("https://api2.jobseekr.in/api/jobs/$i"),
        headers: {
          'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>>? getAllJobsByCompanyId(int i) async {
    try {
      final response = await http.get(
        Uri.parse("https://api2.jobseekr.in/api/jobs/company/$i"),
        headers: {
          'Content-Type': 'application/json',
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
