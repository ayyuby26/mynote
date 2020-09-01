import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mynote/editor_page.dart';
import 'package:mynote/model/notes.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Note"),
      ),
      body: FutureBuilder(
        future: Hive.openBox("notes"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Center(child: Text("error"));
            else {
              var notesBox = Hive.box("notes");
              if (notesBox.length == 0)
              // notes.add(Notes("id1", "title1", "body1"));
              {
                return Center(child: Text("belum ada data"));
              } else {
                // notes.deleteAt(0);
                print(DateTime.now());
                // ignore: deprecated_member_use
                return WatchBoxBuilder(
                  box: notesBox,
                  builder: (_, v) => ListView.builder(
                      itemCount: notesBox.length,
                      itemBuilder: (_, i) {
                        Notes note = notesBox.getAt(i);
                        return Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditorPage(
                                            id: i,
                                            title: note.title,
                                            content: NotusDocument.fromJson(
                                                jsonDecode(note.body)),
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(note.title),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            }
          } else
            return Center(
              child: CupertinoActivityIndicator(
                radius: 30,
              ),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _loadDocument();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EditorPage(
                        title: "",
                        content: _loadDocument(),
                      )));
        },
      ),
    );
  }

  NotusDocument _loadDocument() {
    // final file = File(Directory.systemTemp.path + '/quick_start.json');
    // if (await file.exists()) {
    //   final contents = await file
    //       .readAsString()
    //       .then((data) => Future.delayed(Duration(seconds: 1), () => data));
    //   return NotusDocument.fromJson(jsonDecode(contents));
    // }
    final delta = Delta()..insert('\n');
    return NotusDocument.fromDelta(delta);
  }
}
