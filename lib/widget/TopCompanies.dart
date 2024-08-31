import 'package:flutter/material.dart';
import 'package:jobseekr/Service/CompanyService.dart';
import 'package:jobseekr/pages/company/CompanyScreen.dart';
import 'package:jobseekr/widget/Navigation.dart';

class TopCompanies extends StatefulWidget {
  const TopCompanies({Key? key}) : super(key: key);

  @override
  State<TopCompanies> createState() => _TopCompaniesState();
}

class _TopCompaniesState extends State<TopCompanies> {
  List<Map<String, dynamic>> companyData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllCompanies();
  }

  Future<void> getAllCompanies() async {
    try {
      CompanyService cService = CompanyService();
      List<Map<String, dynamic>>? companies = await cService.getAllCompanies();
      setState(() {
        companyData = companies ?? [];
        isLoading = false;
      });
    } catch (ex) {
      print('Error fetching companies: $ex');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text("Loading..."),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: companyData.map((company) {
                      return _buildCompanyCard(company, context);
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company, context) {
    return GestureDetector(
        onTap: () {
          Navigation(CompanyScreen(company), context);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
              border: Border.all(
            color: Color.fromARGB(255, 245, 245, 245),
          )),
          child: Card(
            color: Colors.white,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    company["logoUrl"] ?? "",
                    height: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    company["companyName"] != null &&
                            company["companyName"].length > 12
                        ? '${company["companyName"].substring(0, 12)}...'
                        : company["companyName"] ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        company["industry"] != null &&
                                company["industry"].length > 11
                            ? '${company["industry"].substring(0, 11)}...'
                            : company["industry"] ?? "",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.star, color: Colors.amber, size: 15),
                      SizedBox(width: 5),
                      Text(
                        "4.0", // Assuming a fixed rating for now
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "View jobs",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
