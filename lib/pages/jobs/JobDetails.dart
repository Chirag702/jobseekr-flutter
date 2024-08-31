import 'package:html/dom.dart' as dom;

import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:intl/intl.dart';
import 'package:jobseekr/Service/JobService.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:html/parser.dart' as html_parser;

class JobDetails extends StatefulWidget {
  final String id;
  const JobDetails(this.id, {Key? key}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  Map<String, dynamic> jobsData = {};
  bool _isExpanded = false;
  bool isLoading = true;
  bool isApplied = false;
  bool isApply = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchFullData();
    fetchUserDetails();
    checkIfJobIsApplied();
  }

  void fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });

    UserService userService = UserService();
    var user = await userService.getUserProfile();
    print("user2468:$user");

    setState(() {
      userData = user;
      isLoading = false; // Set loading to false after data is fetched
    });

    if (userData == null) {
      print("userData is null");
      return;
    }

    bool isJobApply = checkIfJobIsApplied();
    print(isJobApply ? "Job is apply" : "Job is not apply");
    setState(() {
      isApply = isJobApply;
    });
  }

  bool checkIfJobIsApplied() {
    if (userData == null) {
      print("userData is null in checkIfJobIsApply");
      return false;
    }
    if (userData?["applyJobs"] == null) {
      print("savedJobs is null");
      return false;
    }
    return userData?["applyJobs"]
        .any((applyJob) => applyJob["id"].toString() == widget.id);
  }

  deleteJob(id) async {
    try {
      UserService uService = UserService();

      await uService.userdeleteJob(id);
    } catch (e) {
      print('Error fetching job details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  applyJob(id) async {
    try {
      UserService uService = UserService();

      await uService.userSaveJob(id);
    } catch (e) {
      print('Error fetching job details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchFullData() async {
    setState(() {
      isLoading = true;
    });

    try {
      JobService jService = JobService();
      final Map<String, dynamic>? value =
          await jService.getJobById(int.parse(widget.id));

      setState(() {
        jobsData = value ?? {};
      });
    } catch (e) {
      print('Error fetching job details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return _parseElement(document.body!);
  }

  String _parseElement(dom.Element element) {
    final buffer = StringBuffer();

    for (var node in element.nodes) {
      if (node is dom.Text) {
        buffer.write(node.text);
      } else if (node is dom.Element) {
        switch (node.localName) {
          case 'br':
            buffer.write('\n');
            break;
          case 'p':
            buffer.write('\n${_parseElement(node)}\n');
            break;
          case 'ul':
          case 'ol':
            buffer.write('\n${_parseElement(node)}\n');
            break;
          case 'li':
            buffer.write('- ${_parseElement(node)}\n');
            break;
          case 'strong':
            buffer.write('${node.text}');
            break;
          default:
            buffer.write(_parseElement(node));
        }
      }
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(jobsData['title'] ?? 'Job Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: isLoading
            ? Container(
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
                ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                            jobsData['companyDetails']['logoUrl'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    jobsData['title'] ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    jobsData['companyDetails']['companyName'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${jobsData['applicantsCount'] ?? '0'} applicants"),
                      Text(
                        jobsData['postedDate'] != null
                            ? "Posted ${timeago.format(DateTime.parse(jobsData['postedDate']))}"
                            : "",
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(46, 234, 179, 39),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Job highlights",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          jobsData['requirements'] ?? '',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.work_outline,
                            jobsData['seniorityLevel'] ?? ''),
                        _buildDetailRow(Icons.location_on_outlined,
                            jobsData['location'] ?? ''),
                        _buildDetailRow(Icons.location_city,
                            jobsData['employmentType'] ?? ''),
                        _buildDetailRow(
                            Icons.money, jobsData['salaryRange'] ?? ''),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Job Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: ExpandableText(
                      _parseHtmlString(jobsData['description'] ?? ''),
                      style: TextStyle(fontSize: 13, color: Colors.black),
                      trim: 12,
                      readMoreText: 'more',
                      readLessText: 'less',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Company Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCompanyDetail("Industry Type",
                            jobsData['companyDetails']['industry'] ?? ''),
                        SizedBox(height: 20),
                        _buildCompanyDetail(
                            "Department", jobsData['industry'] ?? ''),
                        SizedBox(height: 20),
                        _buildCompanyDetail("Company Type",
                            jobsData['companyDetails']['companyType'] ?? ''),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "About Company",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpandableText(
                          jobsData['companyDetails']['companyDescription'] ??
                              '',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          trim: 3,
                          readMoreText: 'more',
                          readLessText: 'less',
                        ),
                        SizedBox(height: 20),
                        _buildCompanyDetail("Company Name",
                            jobsData['companyDetails']['companyName'] ?? ''),
                        SizedBox(height: 10),
                        _buildCompanyDetail("Headquarters",
                            jobsData['companyDetails']['headquarters'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Similar jobs",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            isApply
                ? Text("Already applied",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))
                : ElevatedButton(
                    onPressed: () {
                      if (isApply) {
                      } else {
                        setState(() {
                          isApply = true;
                        });
                        applyJob(jobsData["id"]);
                      }
                    },
                    child: Text("Apply now",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildCompanyDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}
