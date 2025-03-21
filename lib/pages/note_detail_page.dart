import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/note/note_event.dart';
import '../blocs/note/note_state.dart';
import '../blocs/common/ui_state.dart';
import '../models/note_model.dart';

class NoteDetailPage extends StatefulWidget {
  final String noteId;
  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetNoteById(widget.noteId));
  }

  void _toggleEditMode(NoteModel note) {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        titleController.text = note.title;
        bodyController.text = note.body;
      }
    });
  }

  void _saveChanges() {
    // Here you might dispatch an `UpdateNote` event if needed
    setState(() {
      isEditing = false;
    });
  }

  void _deleteNote() {
    context.read<NoteBloc>().add(DeleteNote(widget.noteId));
    context.go('/notes');
  }

  void _toggleArchive(NoteModel note) {
    if (note.archived) {
      context.read<NoteBloc>().add(UnarchiveNote(widget.noteId));
    } else {
      context.read<NoteBloc>().add(ArchiveNote(widget.noteId));
    }
    context.go('/notes');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        switch (state.singleNote) {
          case Loading():
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case Error(:final message):
            return Center(child: Text('❌ $message'));

          case Success(:final data):
            return Scaffold(
              appBar: AppBar(
                title: isEditing
                    ? const Text("Edit Note")
                    : const Text("Note Details"),
                actions: [
                  if (!isEditing)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _toggleEditMode(data),
                    ),
                  if (!isEditing)
                    IconButton(
                      icon:
                          Icon(data.archived ? Icons.unarchive : Icons.archive),
                      onPressed: () => _toggleArchive(data),
                    ),
                  if (!isEditing)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteNote,
                    ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEditing)
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      )
                    else
                      Text(
                        data.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 12),
                    if (isEditing)
                      TextField(
                        controller: bodyController,
                        decoration: const InputDecoration(labelText: 'Body'),
                        maxLines: 5,
                      )
                    else
                      Text(
                        data.body,
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 24),
                    if (isEditing)
                      ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text("Save Changes"),
                      ),
                  ],
                ),
              ),
            );

          default:
            return const Scaffold(
              body: Center(child: Text('Unknown state')),
            );
        }
      },
    );
  }
}
