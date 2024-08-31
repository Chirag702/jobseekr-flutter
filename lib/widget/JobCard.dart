import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseekr/Service/JobService.dart'; // Assuming JobService retrieves job data
import 'package:jobseekr/pages/jobs/JobDetails.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:html/parser.dart' as html_parser;

class JobCard extends StatefulWidget {
  const JobCard({Key? key}) : super(key: key);

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  List<Map<String, dynamic>> jobsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getJobProfile();
  }

  Future<void> getJobProfile() async {
    try {
      // Replace with your actual service call to fetch jobs
      final JobService jService = JobService();
      List<Map<String, dynamic>>? value = await jService.getAllJobs();

      if (value != null) {
        setState(() {
          jobsData = value;
        });
      } else {
        setState(() {
          jobsData = [];
        });
      }
    } catch (e) {
      print('Error fetching job profiles: $e');
      setState(() {
        jobsData = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245),
      height: 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Jobs based on your \nskill (25)"),
                Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              height: 202,
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: jobsData.map<Widget>((job) {
                  final companyDetails = job['companyDetails'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              JobDetails(job["id"].toString()),
                        ),
                      );
                    },
                    child: Container(
                      height: 202,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    companyDetails['logoUrl'] ?? "",
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                job["title"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    companyDetails['companyName'] ?? "",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 15),
                                  const SizedBox(width: 5),
                                  Text(
                                    job["rating"]?.toString() ?? "N/A",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 20),
                                  const SizedBox(width: 5),
                                  Text(
                                    job["location"],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                timeago
                                    .format(DateTime.parse(job["postedDate"])),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
