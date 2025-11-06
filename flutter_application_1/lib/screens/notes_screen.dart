import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // 🔹 Charger les notes depuis Appwrite
  Future<void> _fetchNotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final fetchedNotes = await _noteService.getNotes();
      setState(() {
        _notes = fetchedNotes;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des notes: $e');
      setState(() {
        _error = 'Erreur lors du chargement des notes.';
        _isLoading = false;
      });
    }
  }

  // 🔹 Ajouter une note
  void _handleNoteAdded(Map<String, dynamic> noteData) async {
    try {
      final newNote = await _noteService.createNote(noteData);
      setState(() {
        _notes.insert(0, newNote);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l’ajout de la note.')),
      );
    }
  }

  // 🔹 Supprimer une note
  void _handleNoteDeleted(String noteId) {
    setState(() {
      _notes.removeWhere((note) => note.$id == noteId);
    });
  }

  // 🔹 Mettre à jour une note
  void _handleNoteUpdated(Document updatedNote) {
    setState(() {
      _notes = _notes.map((note) {
        return note.$id == updatedNote.$id ? updatedNote : note;
      }).toList();
    });
  }

  // 🔹 Ouvrir le modal d’ajout
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(onNoteAdded: _handleNoteAdded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 Titre + bouton d’ajout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vos notes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddNoteDialog,
                  child: const Text('+ Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔸 États
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (_notes.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Aucune note trouvée. Ajoutez-en une !'),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchNotes,
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return NoteItem(
                        note: _notes[index],
                        onNoteDeleted: _handleNoteDeleted,
                        onNoteUpdated: _handleNoteUpdated,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
