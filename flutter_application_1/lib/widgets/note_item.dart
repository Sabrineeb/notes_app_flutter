import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';
import 'edit_note_modal.dart';

class NoteItem extends StatelessWidget {
  final Document note;
  final Function(String) onNoteDeleted;
  final Function(Document) onNoteUpdated;

  const NoteItem({
    Key? key,
    required this.note,
    required this.onNoteDeleted,
    required this.onNoteUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteService = NoteService();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(
          note.data['title'] ?? 'No Title',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          note.data['content'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✏️ Bouton Modifier
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditNoteModal(
                    note: note,
                    onNoteUpdated: onNoteUpdated,
                  ),
                );
              },
            ),

            // 🗑️ Bouton Supprimer
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Supprimer la note'),
                    content: const Text('Voulez-vous vraiment supprimer cette note ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Supprimer'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await noteService.deleteNote(note.$id);
                  onNoteDeleted(note.$id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
