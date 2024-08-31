import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobseekr/Service/CompanyService.dart';
import 'package:jobseekr/widget/Tags.dart';
import 'package:jobseekr/pages/jobs/JobDetails.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../../widget/SavedJobCard.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({Key? key}) : super(key: key);

  @override
  State<SearchJobScreen> createState() => _SearchJobScreenState();
}

class _SearchJobScreenState extends State<SearchJobScreen> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> companyData = [];
  bool isLoading = false;

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    String keyword = _searchController.text.trim();

    if (keyword.length < 3) {
      setState(() {
        isValid = false;
        companyData.clear();
        isLoading = false;
      });
    } else {
      setState(() {
        isValid = true;
        isLoading = true;
      });

      try {
        List<Map<String, dynamic>>? companies = await getAllCompanies(keyword);

        setState(() {
          companyData = companies!;
          isLoading = false;
        });
      } catch (ex) {
        print('Error fetching companies: $ex');
        setState(() {
          isLoading = false;
          // Handle error state or retry logic here
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>?> getAllCompanies(String keyword) async {
    try {
      CompanyService cService = CompanyService();
      List<Map<String, dynamic>>? companies = await cService.getAllCompanies();

      List<Map<String, dynamic>> filteredCompanies = [];

      if (companies != null) {
        for (var company in companies) {
          List<dynamic> jobs = company['jobs'] as List<dynamic>? ?? [];

          // Check if the company name or any job field contains the keyword
          if (_companyMatchesKeyword(company, keyword) ||
              jobs.any((job) => _jobMatchesKeyword(job, keyword))) {
            filteredCompanies.add(company);
          }
        }
      }

      return filteredCompanies;
    } catch (ex) {
      print('Error fetching companies: $ex');
      throw ex; // Re-throw the exception to handle it in _onSearchChanged()
    }
  }

  bool _companyMatchesKeyword(Map<String, dynamic> company, String keyword) {
    // Convert the keyword to lowercase for case insensitive comparison
    String lowercaseKeyword = keyword.toLowerCase();

    // Check if any field in the company contains the lowercase keyword as a substring
    return company.values.any((value) {
      if (value is String) {
        return value.toLowerCase().contains(lowercaseKeyword);
      }
      return false; // Handle other types if needed
    });
  }

  bool _jobMatchesKeyword(Map<String, dynamic> job, String keyword) {
    // Convert the keyword to lowercase for case insensitive comparison
    String lowercaseKeyword = keyword.toLowerCase();

    // Check if any field in the job contains the lowercase keyword as a substring
    return job.values.any((value) {
      if (value is String) {
        return value.toLowerCase().contains(lowercaseKeyword);
      }
      return false; // Handle other types if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: MediaQuery.of(context).size.width * 0.95,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 45.0,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16.0),
                        cursorColor: Colors.blue, // Set cursor color
                        onChanged: (value) {
                          _onSearchChanged();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            !isValid
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Popular Searches",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Wrap(
                          spacing: 8.0,
                          children: [
                            // Example tags, replace with your own
                            Chip(label: Text("Work From Home Jobs")),
                            Chip(label: Text("Data Entry Operator")),
                            Chip(label: Text("Part Time Jobs")),
                            Chip(label: Text("Security Guard")),
                            Chip(label: Text("Telecaller")),
                          ],
                        ),
                      ),
                    ],
                  )
                : isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: companyData.length,
                        itemBuilder: (context, index) {
                          print("Company length ${companyData.length}");
                          final company = companyData[index];
                          final jobs = company['jobs'] as List<dynamic>? ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: jobs.map<Widget>((job) {
                              return ListTile(
                                title: Text(job['title']),
                                subtitle: Text(job['location']),
                                onTap: () {
                                  // Navigate to job details page
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         JobDetailsScreen(job: job),
                                  //   ),
                                  // );
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
