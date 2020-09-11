import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mynote/core/models/notes.dart';

class MapProvider with ChangeNotifier{
  //------------------------//
  //   PROPERTY SECTIONS    //
  //------------------------//

  /// list of saved notes
   // ignore: prefer_final_fields
   List<MyNote> _noteList = [];
  List<MyNote> get noteList => _noteList;

  /// mode to edit notes
  bool _editingMode = false;
  bool get editingMode => _editingMode;

  // ignore: prefer_final_fields
  bool _snackbarStatus = false;
  bool get snackbarStatus => _snackbarStatus;

  //------------------------//
  //    FUNCTION SECTIONS   //
  //------------------------//

  /// to Load Note
  void loadNote(String _list) {
    final t = jsonDecode(_list);
    t.map((e) => _noteList.add(MyNote.fromJson(e))).toList();
    // notifyListeners();
  }

  /// to Add Note
  void addNote(String _title, String _contents)  {
    final _id = DateTime.now().toString();
    final _note = MyNote(_id, _title, _contents);
    _noteList.add(_note);
    var _notes = jsonEncode(_noteList);

    final _box = GetStorage();

    _box.write('notes', _notes);
    notifyListeners();
  }

  /// to Add Note At
  void addNoteAt(int i, MyNote _myNote) {
    _noteList.insert(i, _myNote);
    notifyListeners();
  }

  /// to Edit Note
  void editNote(String _id, String _title, String _contents) {
    _noteList.map((v) {
      if (v.id == _id) {
        v.title = _title;
        v.content = _contents;
      }
    }).toList();
    notifyListeners();
  }

  /// to delete note
  void clrAt(int index) {
    _noteList.removeAt(index);
    final _box = GetStorage();
    _box.write('notes', jsonEncode(_noteList));
    notifyListeners();
  }

  /// to togle editingmode to true
  void editingModeTrue() {
    _editingMode = true;
    notifyListeners();
  }

  /// to togle editingmode to false
  void editingModeFalse() {
    _editingMode = false;
    notifyListeners();
  }

}
