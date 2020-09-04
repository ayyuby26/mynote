import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynote/const.dart';
import 'package:mynote/cubit/notes_cubit/notes_cubit.dart';
import 'package:zefyr/zefyr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/notes.dart';

class EditorPage extends StatefulWidget {
  final String id;
  final String title;
  final NotusDocument content;
  final GlobalKey<AnimatedListState> animatedListKey;
  final List<MyNote> list;

  const EditorPage({
    this.id,
    @required this.title,
    @required this.content,
    @required this.animatedListKey,
    @required this.list,
  });

  @override
  _EditorPageState createState() => _EditorPageState(
        id: id,
        title: title,
        content: content,
        animatedListKey: animatedListKey,
        list: list,
      );
}

class _EditorPageState extends State<EditorPage> {
  final _titleKeyTextField = GlobalKey(debugLabel: "zxc");

  final _titleController = TextEditingController();
  ZefyrController _bodyController;

  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  final String id;
  final String title;
  NotusDocument content;
  final GlobalKey<AnimatedListState> animatedListKey;
  final List<MyNote> list;

  _EditorPageState({
    this.id,
    @required this.title,
    @required this.content,
    @required this.animatedListKey,
    @required this.list,
  });

  @override
  Widget build(BuildContext context) {
    Widget body(bool _editingMode) => _bodyController == null
        ? Center(child: Center(child: CupertinoActivityIndicator(radius: 30)))
        : ZefyrScaffold(
            child: Obx(
              () => ZefyrEditor(
                  autofocus: false,
                  mode: _editingMode ? ZefyrMode.edit : ZefyrMode.select,
                  padding: EdgeInsets.all(16),
                  controller: _bodyController,
                  focusNode: _contentFocusNode,
                  keyboardAppearance: Brightness.light),
            ),
          );

    void _saveNote(BuildContext context) {
      final _notesCubit = context.bloc<NotesCubit>();
      final title = _titleController.text;
      final content = _bodyController.document;

      if (title.isEmpty && content.length == 1)
        Get.snackbar(
          "Warning",
          'must fill at least one column.',
          colorText: white,
        );
      else {
        final contents = jsonEncode(content);
        if (id.isNull) {
          final _n = list;
          final _i = _n.isEmpty ? 0 : _n.length - 1;
          final _animKey = animatedListKey.currentState;

          _notesCubit.addMyNote(title, contents);
          if (_animKey != null) _animKey.insertItem(_i);
          Navigator.pop(context);
          Get.snackbar("Message", 'Note added', colorText: white);
        } else {
          _notesCubit.editMyNote(id, title, contents);
          Get.snackbar("Message", "Saved", colorText: white);
          _notesCubit.editingModeFalse();
        }
      }
    }

// obx dan blocbuilder tadi dihapus

    final _notesCubit = context.bloc<NotesCubit>();
    _notesCubit.setEditingMode();

    return BlocBuilder<NotesCubit, NotesState>(builder: (context, state) {
      final _editingMode = state.props[2] as bool;
      print(state.props[2] ?? "null bro");
      return Scaffold(
        appBar: AppBar(
          title: Obx(
            () => TextField(
              cursorWidth: 1.5,
              cursorColor: white,
              style: TextStyle(
                decorationThickness: 2,
                color: white,
              ),
              enabled: _editingMode ? true : false,
              key: _titleKeyTextField,
              focusNode: _titleFocusNode,
              controller: _titleController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white60),
                // fillColor: Colors.white,
                // focusColor: Colors.white,
                border: InputBorder.none,
                hintText: "note title",
              ),
            ),
          ),
          actions: <Widget>[
            Obx(
              () => IconButton(
                icon: Icon(_editingMode
                    ? MaterialCommunityIcons.feather
                    : CupertinoIcons.pen),
                onPressed: () {
                  if (_editingMode) {
                    _saveNote(context);
                  } else
                    _notesCubit.editingModeTrue();
                },
              ),
            ),
          ],
        ),
        body: body(_editingMode),
      );
    });
  }
}
