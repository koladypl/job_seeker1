import 'package:html_unescape/html_unescape.dart';

class JobOffer {
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String salary;

  JobOffer({
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.salary,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    final description = unescape.convert(json['description'] ?? '');  

    return JobOffer(
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      location: json['location'] ?? '',
      description: description, 
      salary: json['salary'] ?? 'Not specified',
    );
  }
}
