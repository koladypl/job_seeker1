import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_seeker/job_offer.dart';


class ApiService {
  static const String _baseUrl = 'https://www.arbeitnow.com/api/job-board-api'; // URL API

  static Future<List<JobOffer>> fetchJobOffers() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Upewniamy się, że `data` to lista
      final List<dynamic> jobData = jsonData['data'];

      // Konwertujemy listę na obiekty JobOffer
      return jobData.map((json) => JobOffer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load job offers');
    }
  }
}
