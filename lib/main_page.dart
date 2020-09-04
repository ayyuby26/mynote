import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynote/editor_page.dart';
import 'package:mynote/notes_list.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

import 'cubit/notes_cubit/notes_cubit.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _animatedListKey = GlobalKey<AnimatedListState>(debugLabel: "anim");
  final _keyScaff = GlobalKey<ScaffoldState>(debugLabel: "scaff");
  final _keyScaff1 = GlobalKey<ScaffoldState>(debugLabel: "scaf1");

  @override
  void dispose() {
    context.bloc<NotesCubit>().timerCancel();
    super.dispose();
  }

  final _offSetTween = Tween(
    begin: const Offset(1, 0),
    end: Offset.zero,
  );

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'en_US';

    return BlocBuilder<NotesCubit, NotesState>(builder: (context, state) {
      final int _deleteTiming = state.props[1];
      final NotesCubit _notesCubit = context.bloc<NotesCubit>();
      print(state.props[2] ?? "null bruh");
      //TODO: ganti veri zefyr karena gk cocok dengan hydrated_bloc dengan syarat harus ganti2 project
      return Scaffold(
        key: _keyScaff,
        appBar: AppBar(
          title: Text("My Notes"),
        ),
        body: NotesList(
          animatedListKey: _animatedListKey,
          keyScaff: _keyScaff1,
          offSetTween: _offSetTween,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "+",
          child: Icon(Icons.add),
          onPressed: () {
            _keyScaff.currentState.hideCurrentSnackBar();
            print(_deleteTiming);
            if (_deleteTiming != 10 && _notesCubit.getTimer() != null)
              _notesCubit.timerCancel();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditorPage(
                          title: "",
                          content: _loadDocument(),
                          animatedListKey: _animatedListKey,
                          list: [],
                        )));
          },
        ),
      );
    });
  }

  NotusDocument _loadDocument() {
    final delta = Delta()..insert('\n');
    return NotusDocument.fromDelta(delta);
  }
}
