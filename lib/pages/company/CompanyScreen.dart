import 'package:flutter/material.dart';
import 'package:jobseekr/Service/JobService.dart';
import 'package:jobseekr/pages/jobs/JobDetails.dart';
import 'package:jobseekr/widget/Navigation.dart';
import 'package:jobseekr/widget/JobCard.dart';

class CompanyScreen extends StatefulWidget {
  final Map<String, dynamic> company;
  const CompanyScreen(this.company, {Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  Map<String, dynamic>? jobsData;

  @override
  void initState() {
    super.initState();
    getJobByCompanyId();
  }

  getJobByCompanyId() async {
    JobService js = JobService();
    final value = await js.getAllJobsByCompanyId(widget.company["id"]);
    setState(() {
      jobsData = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          widget.company["companyName"] ?? 'Company Name',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Color.fromARGB(255, 246, 239, 250),
              ),
              Positioned(
                bottom: -30,
                left: (MediaQuery.of(context).size.width / 2) - 30,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                  child: Image.network(widget.company["logoUrl"] ?? ''),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Center(
            child: Text(
              widget.company["companyName"] ?? 'Company Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text("4827 followers",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )),
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
}
