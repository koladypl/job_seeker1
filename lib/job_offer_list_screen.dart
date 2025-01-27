import 'package:flutter/material.dart';
import 'package:job_seeker/JobOfferDetailsScreen.dart';
import 'package:job_seeker/services/api_service.dart';
import 'job_offer.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart' as html_parser;

class JobOffersListScreen extends StatefulWidget {
  final Function toggleTheme;
  JobOffersListScreen({required this.toggleTheme});

  @override
  _JobOffersListScreenState createState() => _JobOffersListScreenState();
}

class _JobOffersListScreenState extends State<JobOffersListScreen> {
  late Future<List<JobOffer>> jobOffers;
  List<JobOffer> filteredJobOffers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    jobOffers = ApiService.fetchJobOffers(); 

    jobOffers.then((offers) {
      setState(() {
        filteredJobOffers = offers;  
      });
    });

   
    searchController.addListener(_filterSearchResults);
  }

 
  String cleanDescription(String description) {
    final document = html_parser.parse(description);
    final cleanText = document.body?.text ?? '';
    
    // Usuwamy wszystkie style i inne niepotrzebne elementy
    final cleanedDescription = cleanText.replaceAll(RegExp(r'[\n\r\t]'), ' ').trim(); 

    return cleanedDescription;
  }

  
  void _filterSearchResults() {
    setState(() {
      filteredJobOffers = filteredJobOffers.where((jobOffer) {
        return jobOffer.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
               jobOffer.companyName.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/job_logo.png',  
              height: 40.0,  
            ),
            SizedBox(width: 10), 
            Text('I am looking for a job'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.brightness_7
                  : Icons.brightness_4,
            ),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Job Offers',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<JobOffer>>(
              future: jobOffers, // tu musze pobrac z niemieckiego api
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No job offers available'));
                } else {
                  final jobOffers = snapshot.data!;

                  if (filteredJobOffers.isEmpty) {
                    filteredJobOffers = jobOffers;
                  }

                  return ListView.builder(
                    itemCount: filteredJobOffers.length,
                    itemBuilder: (context, index) {
                      final jobOffer = filteredJobOffers[index];
                      
                      String cleanDesc = cleanDescription(jobOffer.description);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobOfferDetailsScreen(
                                    title: jobOffer.title,
                                    companyName: jobOffer.companyName,
                                    location: jobOffer.location,
                                    description: cleanDesc, 
                                    salary: jobOffer.salary,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade200, Colors.blue.shade400],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.work, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        jobOffer.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    jobOffer.companyName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    jobOffer.location,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    cleanDesc.length > 100
                                        ? cleanDesc.substring(0, 100) + '...'
                                        : cleanDesc,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    "Salary: ${jobOffer.salary}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
