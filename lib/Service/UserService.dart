import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<void> saveProfile(Map<String, dynamic> profileData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      return;
    }

    print("profileData: $profileData");
    final url =
        'https://api2.jobseekr.in/api/user/profile'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(profileData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('DOB saved successfully');
      } else {
        print('Failed to save DOB. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving DOB: $e');
    }
  }

  Future<void> userSaveJob(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      return;
    }

    final url =
        'https://api2.jobseekr.in/api/user/profile/job/save'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"id": id}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('DOB saved successfully');
      } else {
        print('Failed to save DOB. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving DOB: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token')?.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      print('Token is null');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse("https://api2.jobseekr.in/api/user/profile"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          print(data["link"]);
          return data;
        } else {
          print('Error: Data is not a map.');
          return null;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> deleteProfileLinks(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      return;
    }

    final url =
        'https://api2.jobseekr.in/api/user/profile/link'; // Replace with your API endpoint

    try {
      final response = await http.delete(
        Uri.parse(url),
        body: json.encode({
          "link": [
            {"id": id}
          ]
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('DOB saved successfully');
      } else {
        print('Failed to save DOB. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving DOB: $e');
    }
  }

  Future<void> sendInvitation(String recipient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      return;
    }

    final url =
        'https://api2.jobseekr.in/api/invite'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"recipient": recipient}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('DOB saved successfully');
      } else {
        print('Failed to save DOB. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving DOB: $e');
    }
  }

  Future<List<dynamic>?> getUserProfileViews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token')?.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      print('Token is null');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse("https://api2.jobseekr.in/api/profile-views"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List<dynamic>) {
          print(data);
          return data;
        } else {
          print('Error: Data is not a map.');
          return null;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> userdeleteJob(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      return;
    }

    final url =
        'https://api2.jobseekr.in/api/user/profile/job/remove'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"id": id}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('DOB saved successfully');
      } else {
        print('Failed to save DOB. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving DOB: $e');
    }
  }
}
