import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/note/note_event.dart';
import '../blocs/note/note_state.dart';
import '../blocs/common/ui_state.dart';

class ArchivedNotesPage extends StatefulWidget {
  const ArchivedNotesPage({super.key});

  @override
  State<ArchivedNotesPage> createState() => _ArchivedNotesPageState();
}

class _ArchivedNotesPageState extends State<ArchivedNotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetArchivedNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archived Notes')),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          switch (state.archivedNotes) {
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
    );
  }
}
