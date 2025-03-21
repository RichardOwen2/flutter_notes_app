import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/note/note_event.dart';
import '../blocs/note/note_state.dart';
import '../blocs/common/ui_state.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () => context.go('/notes/archived'),
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          switch (state.notes) {
            case Loading():
              return const Center(child: CircularProgressIndicator());

            case Error(:final message):
              return Center(child: Text('❌ $message'));

            case Success(:final data):
              if (data.isEmpty) {
                return const Center(child: Text('No notes found. Add some!'));
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final note = data[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => context.go('/notes/${note.id}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.archive_outlined),
                      onPressed: () {
                        context.read<NoteBloc>().add(ArchiveNote(note.id));
                      },
                    ),
                  );
                },
              );

            default:
              return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/notes/create'), // Navigate to Create Note
        child: const Icon(Icons.add),
      ),
    );
  }
}
