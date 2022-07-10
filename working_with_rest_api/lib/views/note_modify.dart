import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:working_with_rest_api/models/note.dart';
import 'package:working_with_rest_api/services/note_service.dart';

class NoteModify extends StatefulWidget {
  final String? noteID;
  const NoteModify({Key? key, this.noteID}) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String? errorMessage;
  late Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isloading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isloading = true;
    });
    
    notesService.getNote(widget.noteID!).then((response) {
      setState(() {
      _isloading = false;
    });
      if (response.error) {
        errorMessage = response.errorMessage ?? 'An error occured';
      }
      note = response.data!;
      _titleController.text = note.noteTitle;
      _contentController.text = note.noteContent;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isloading ? Center(child: CircularProgressIndicator()) : Column(children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Note title'),
          ),
          Container(height: 8),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(hintText: 'Note content'),
          ),
          Container(height: 16),
          SizedBox(
            width: double.infinity,
            height: 35,
            // ignore: deprecated_member_use
            child: RaisedButton(
              child: Text('Submit', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ]),
      ),
    );
  }
}
