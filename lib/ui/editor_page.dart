import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import 'package:zefyr/zefyr.dart';
import 'package:provider/provider.dart';
import '../core/viewmodels/map_provider.dart';
import 'images.dart';

class EditorPage extends StatefulWidget {
  final String id;
  final String title;
  final NotusDocument content;
  final GlobalKey<AnimatedListState> animatedListKey;

  const EditorPage({
    this.id,
    @required this.title,
    @required this.content,
    @required this.animatedListKey,
  });

  @override
  _EditorPageState createState() => _EditorPageState(
        id: id,
        title: title,
        content: content,
        animatedListKey: animatedListKey,
      );
}

class _EditorPageState extends State<EditorPage> {
  final _keyScaff = GlobalKey<ScaffoldState>(debugLabel: 'scaffEditor');
  final _titleKeyTextField = GlobalKey(debugLabel: 'zxc');

  final _titleController = TextEditingController();
  ZefyrController _bodyController;

  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  final String id;
  final String title;
  NotusDocument content;
  final GlobalKey<AnimatedListState> animatedListKey;

  _EditorPageState({
    this.id,
    @required this.title,
    @required this.content,
    @required this.animatedListKey,
  });

  @override
  void initState() {
    _titleController.text = title;
    _bodyController = ZefyrController(content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<MapProvider>();

    if (context.watch<MapProvider>().editingMode) {
      _titleFocusNode.requestFocus();
    } else {
      _titleFocusNode.unfocus();
      _contentFocusNode.unfocus();
    }

    void _saveNote() {
      final title = _titleController.text;
      final content = _bodyController.document;
      if (title.isEmpty && content.length == 1)
        // ignore: curly_braces_in_flow_control_structures
        Get.snackbar(
          'Warning',
          'must fill at least one column.',
          colorText: white,
        );
      else {
        final contents = jsonEncode(content);

        if (id.isNull) {
          final _n = _provider.noteList;
          final _i = _n.isEmpty ? 0 : _n.length;
          final _animKey = animatedListKey.currentState;

          _provider.addNote(title, contents);
          if (_animKey != null) _animKey.insertItem(_i);
          Navigator.pop(context);

          Get.snackbar('Success', 'Note added', colorText: white);
        } else {
          _provider.editNote(id, title, contents);
          Get.snackbar('Success', 'Note saved', colorText: white);
          _provider.editingModeFalse();
        }
      }
    }

    return Scaffold(
      key: _keyScaff,
      appBar: AppBar(
        title: TextField(
          cursorWidth: 1.5,
          cursorColor: white,
          style: TextStyle(
            decorationThickness: 2,
            color: white,
          ),
          enabled: _provider.editingMode ? true : false,
          key: _titleKeyTextField,
          focusNode: _titleFocusNode,
          controller: _titleController,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white60),
            // fillColor: Colors.white,
            // focusColor: Colors.white,
            border: InputBorder.none,
            hintText: 'note title',
          ),
          onSubmitted: (value) => _contentFocusNode.requestFocus(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_provider.editingMode
                ? MaterialCommunityIcons.content_save_edit
                : CupertinoIcons.pen),
            onPressed: () {
              if (_provider.editingMode) {
                _saveNote();
                _titleFocusNode.unfocus();
                _contentFocusNode.unfocus();
              } else {
                _provider.editingModeTrue();
                Future.delayed(Duration(milliseconds: 50)).whenComplete(() =>
                    _titleController.text.isEmpty
                        ? _titleFocusNode.requestFocus()
                        : _contentFocusNode.requestFocus());
              }
            },
          ),
        ],
      ),
      body: _bodyController == null
          ? Center(child: Center(child: CupertinoActivityIndicator(radius: 30)))
          : ZefyrScaffold(
              child: ZefyrEditor(
                  autofocus: false,
                  mode:
                      _provider.editingMode ? ZefyrMode.edit : ZefyrMode.select,
                  padding: EdgeInsets.all(16),
                  controller: _bodyController,
                  focusNode: _contentFocusNode,
                  imageDelegate: CustomImageDelegate(),),
            ),
    );
  }
}
