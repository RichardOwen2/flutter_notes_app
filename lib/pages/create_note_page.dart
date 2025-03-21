import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/note/note_event.dart';
import '../blocs/note/note_state.dart';
import '../blocs/common/ui_state.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  void _submit() {
    context.read<NoteBloc>().add(CreateNote(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state.actionState is Success<String>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text((state.actionState as Success<String>).data)),
          );
          context.go('/notes');
        }
        if (state.actionState is Error<String>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text((state.actionState as Error<String>).message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.actionState is Loading;

        return Scaffold(
          appBar: AppBar(title: const Text('Create Note')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Text("Create Note"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
