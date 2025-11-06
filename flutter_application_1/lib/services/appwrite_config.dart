// lib/appwrite_config.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Client getClient() {
  final client = Client()
    ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!) // Exemple: 'http://localhost/v1'
    ..setProject(dotenv.env['APPWRITE_PROJECT_ID']!) // Ton project ID Appwrite
    ..setSelfSigned(status: true); // True si tu es en local
  return client;
}
