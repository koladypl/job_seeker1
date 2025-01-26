import 'package:flutter/material.dart';
import 'job_offer.dart'; 

class JobOfferDetailsScreen extends StatelessWidget {
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String salary;

  JobOfferDetailsScreen({
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: $companyName', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Location: $location', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Salary: $salary', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Description:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
