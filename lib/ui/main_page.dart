import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mynote/core/viewmodels/map_provider.dart';
import 'package:mynote/ui/notes_empty.dart';
import 'package:mynote/ui/notes_list.dart';
import 'editor_page.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _animatedListKey = GlobalKey<AnimatedListState>(debugLabel: 'anim');
  final _keyScaff = GlobalKey<ScaffoldState>(debugLabel: 'scaff');

  final ValueNotifier<int> _deleteTiming = ValueNotifier<int>(10);

  /// countdown delete note
  Timer _timer;

  final _box = GetStorage();

  @override
  void initState() {
    if (_box.hasData('notes'))
      // ignore: curly_braces_in_flow_control_structures
      context.read<MapProvider>().loadNote(_box.read('notes'));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final _offSetTween = Tween(
    begin: const Offset(1, 0),
    end: Offset.zero,
  );

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'en_US';
    final _provider = context.watch<MapProvider>();

    return Scaffold(
      key: _keyScaff,
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: _provider.noteList.isNotEmpty
          ? NotesList(
              animatedListKey: _animatedListKey,
              deleteTiming: _deleteTiming,
              keyScaff: _keyScaff,
              offSetTween: _offSetTween,
              provider: _provider,
              timer: _timer,
            )
          : NotesEmpty(),
      floatingActionButton: FloatingActionButton(
        heroTag: '+',
        child: Icon(Icons.add),
        onPressed: () {
          _onPressed(_provider);
        },
      ),
    );
  }

  NotusDocument _loadDocument() {
    final delta = Delta()..insert('\n');
    return NotusDocument.fromDelta(delta);
  }

  void _onPressed(MapProvider _provider) {
    _provider.editingModeTrue();
    _keyScaff.currentState.hideCurrentSnackBar();
    if (_deleteTiming.value != 10) _timer.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditorPage(
          title: '',
          content: _loadDocument(),
          animatedListKey: _animatedListKey,
        ),
      ),
    );
  }
}
