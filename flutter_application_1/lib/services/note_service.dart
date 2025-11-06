import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './appwrite_config.dart';

class NoteService {
  final Client _client = getClient();
  late final Databases _databases;

  NoteService() {
    _databases = Databases(_client);
  }

  // 🔹 Récupérer toutes les notes
  Future<List<Document>> getNotes({String? userId}) async {
    try {
      List<String> queries = [];

      if (userId != null) {
        queries.add(Query.equal('userId', userId));
      }

      // ⚠️ On ne trie plus par "createdAt", car ce champ n'existe pas
      // Appwrite possède déjà $createdAt (avec un $)
      queries.add(Query.orderDesc('\$createdAt'));

      final response = await _databases.listDocuments(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        queries: queries,
      );

      return response.documents;
    } catch (e) {
      print('❌ Error getting notes: $e');
      rethrow;
    }
  }

  // 🔹 Créer une note
  Future<Document> createNote(Map<String, dynamic> data) async {
    try {
      final response = await _databases.createDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: ID.unique(),
        data: data, // Ne pas ajouter createdAt/updatedAt manuellement
      );
      return response;
    } catch (e) {
      print('❌ Error creating note: $e');
      rethrow;
    }
  }

  // 🔹 Supprimer une note
  Future<void> deleteNote(String noteId) async {
    try {
      await _databases.deleteDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
      );
    } catch (e) {
      print('❌ Error deleting note: $e');
      rethrow;
    }
  }

  // 🔹 Mettre à jour une note
  Future<Document> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      final response = await _databases.updateDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
        data: data,
      );
      return response;
    } catch (e) {
      print('❌ Error updating note: $e');
      rethrow;
    }
  }
}
