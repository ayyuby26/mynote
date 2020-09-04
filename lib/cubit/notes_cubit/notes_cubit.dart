import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mynote/model/notes.dart';
import 'package:zefyr/zefyr.dart';

part 'notes_state.dart';

class NotesCubit extends HydratedCubit<NotesState> {
  NotesCubit()
      : super(NotesInitial(
          deleteTiming: 10,
          notesBox: [],
          editingMode: false,
        ));

  void editingModeTrue() => emit(NotesInitial(editingMode: true));

  void editingModeFalse() => emit(NotesInitial(editingMode: false));

  void setEditingMode({
    String id,
    TextEditingController titleController,
    String title,
    NotusDocument content,
    ZefyrController bodyController,
    FocusNode titleFocusNode,
    FocusNode contentFocusNode,
  }) {
    final _editingMode = state.props[2] as bool;

    if (_editingMode != null && _editingMode)
      id == null
          ? emit(NotesInitial(editingMode: true))
          : emit(NotesInitial(editingMode: false));
    else {
      // titleFocusNode.unfocus();
      // contentFocusNode.unfocus();
    }
    titleController.text = title;
    bodyController = ZefyrController(content);
  }

  Timer _timer;
  Timer getTimer() => _timer;

  void timerSetDuration() => emit(NotesInitial(deleteTiming: 10));
  void timerCancel() => _timer.cancel();

  void startTimer() {
    final _deleteTiming = state.props[1] as int;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_deleteTiming < 1)
        timer.cancel();
      else
        emit(NotesInitial(deleteTiming: _deleteTiming - 1));
    });
  }

  void addMyNote(String _title, String _contents) {
    final _id = DateTime.now().toString();
    final _note = MyNote(_id, _title, _contents);
    final _notes = state.props[0] as List<MyNote>;
    _notes.add(_note);
    emit(NotesInitial(notesBox: _notes));
  }

  void clr() {
    final _notes = state.props[0] as List<MyNote>;
    _notes.clear();
  }

  void clrAt(int index) {
    final _notes = state.props[0] as List<MyNote>;
    _notes.removeAt(index);
    emit(NotesInitial(notesBox: _notes));
  }

  void editMyNote(String _id, String _title, String _contents) {
    final _notes = state.props[0] as List<MyNote>;
    _notes.map((v) {
      if (v.id == _id) {
        v.title = _title;
        v.content = _contents;
      }
    }).toList();
    emit(NotesInitial(notesBox: _notes));
  }

  @override
  NotesInitial fromJson(Map<String, dynamic> json) {
    List<MyNote> _ = [];
    var _string = json['Notes'] as String;
    var _list = jsonDecode(_string);
    _list.map((e) => _.add(MyNote.fromJson(e))).toString();
    return NotesInitial(notesBox: _);
  }

  @override
  Map<String, String> toJson(NotesState state) =>
      {"Notes": json.encode(state.props[0] as List<MyNote>)};
}
