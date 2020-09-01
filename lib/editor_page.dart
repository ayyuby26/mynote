import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zefyr/zefyr.dart';
import 'model/notes.dart';

class EditorPage extends StatefulWidget {
  final int id;
  final String title;
  final NotusDocument content;

  const EditorPage({
    this.id,
    @required this.title,
    @required this.content,
  });

  @override
  _EditorPageState createState() => _EditorPageState(
        id: id,
        title: title,
        content: content,
      );
}

class _EditorPageState extends State<EditorPage> {
  final _titleController = TextEditingController();
  ZefyrController _bodyController;

  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  final int id;
  final String title;
  NotusDocument content;

  _EditorPageState({
    this.id,
    @required this.title,
    @required this.content,
  });

  @override
  void initState() {
    super.initState();
    setState(() {
      _titleController.text = title;
      _bodyController = ZefyrController(content);
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = (_bodyController == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _bodyController,
              focusNode: _contentFocusNode,
            ),
          );

    id == null
        ? _titleFocusNode.requestFocus()
        : _contentFocusNode.requestFocus();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _titleFocusNode,
          controller: _titleController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "note title",
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly:
    final contents = jsonEncode(_bodyController.document);
    // For this example we save our document to a temporary file.
    // final file = File(Directory.systemTemp.path + '/quick_start.json');
    // And show a snack bar on success.
    print(contents);
    var notes = Hive.box("notes");

    if (id == null) {
      notes
          .add(
              Notes(DateTime.now().toString(), _titleController.text, contents))
          .then((value) {
        print(value);
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Saved.')));
      });
    } else
      notes.putAt(id,
          Notes(DateTime.now().toString(), _titleController.text, contents));
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Saved.')));
    // file.writeAsString(contents).then((_) {
    //   Scaffold.of(context).showSnackBar(SnackBar(content: Text('Saved.')));
    // });
  }
}
