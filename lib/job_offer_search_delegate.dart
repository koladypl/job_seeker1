import 'package:flutter/material.dart';
import 'package:job_seeker/job_offer.dart'; 

class JobOfferSearchDelegate extends SearchDelegate {
  final List<JobOffer> jobOffers = []; 

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<JobOffer> results = jobOffers
        .where((jobOffer) =>
            jobOffer.title.toLowerCase().contains(query.toLowerCase()) ||
            jobOffer.companyName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final jobOffer = results[index];
        return ListTile(
          title: Text(jobOffer.title),
          subtitle: Text(jobOffer.companyName),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<JobOffer> suggestions = jobOffers
        .where((jobOffer) =>
            jobOffer.title.toLowerCase().contains(query.toLowerCase()) ||
            jobOffer.companyName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final jobOffer = suggestions[index];
        return ListTile(
          title: Text(jobOffer.title),
          subtitle: Text(jobOffer.companyName),
        );
      },
    );
  }
}
