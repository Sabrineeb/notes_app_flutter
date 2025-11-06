import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';

class EditNoteModal extends StatefulWidget {
  final Document note;
  final Function(Document) onNoteUpdated;

  const EditNoteModal({
    Key? key,
    required this.note,
    required this.onNoteUpdated,
  }) : super(key: key);

  @override
  _EditNoteModalState createState() => _EditNoteModalState();
}

class _EditNoteModalState extends State<EditNoteModal> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _noteService = NoteService();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.data['title']);
    _contentController = TextEditingController(text: widget.note.data['content']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      setState(() => _error = 'Veuillez remplir tous les champs.');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final updateData = {'title': title, 'content': content};
      final updatedNote =
          await _noteService.updateNote(widget.note.$id, updateData);

      widget.onNoteUpdated(updatedNote);
      Navigator.pop(context);
    } catch (e) {
      print('Erreur lors de la mise à jour: $e');
      setState(() => _error = 'Échec de la mise à jour.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Modifier la note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Contenu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
