import 'package:flutter/material.dart';
import 'package:jobseekr/Service/JobService.dart';
import 'package:jobseekr/Service/UserService.dart';

class SavedJobCard extends StatefulWidget {
  const SavedJobCard({Key? key}) : super(key: key);

  @override
  State<SavedJobCard> createState() => _SavedJobCardState();
}

class _SavedJobCardState extends State<SavedJobCard> {
  bool isLoading = false;
  Map<String, dynamic>? userProfile = {};
  List<dynamic> _savedJobs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserService userService = UserService();
      var user = await userService.getUserProfile();
      setState(() {
        _savedJobs = user?["applyJobs"] ?? [];
        userProfile = user;
      });
      print(_savedJobs);
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch data");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: _savedJobs.length,
              itemBuilder: (context, index) {
                final job = _savedJobs[index];
                final companyName = job['company'] ?? 'Unknown';
                final companyRating =
                    job['companyDetails']?["rating"]?.toString() ??
                        'N/A'; // Adjusted based on new structure
                return JobCard(
                  title: job['title'] ?? 'Unknown Title',
                  company: companyName,
                  location: job['location'] ?? 'Unknown Location',
                  rating: companyRating,
                );
              },
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height - 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Image.asset("assets/load.gif", height: 20),
                  ),
                )
              ],
            ));
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String rating;

  const JobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.rating,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                company,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 15),
                  SizedBox(width: 5),
                  Text(
                    rating,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 20, color: Colors.black),
                  SizedBox(width: 5),
                  Text(
                    location,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Applied 4 days ago",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    "Similar jobs",
                    style: TextStyle(fontSize: 12, color: Colors.blueAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
