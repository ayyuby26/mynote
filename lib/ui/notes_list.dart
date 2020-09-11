import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynote/core/models/notes.dart';
import 'package:mynote/core/viewmodels/map_provider.dart';
import 'package:zefyr/zefyr.dart';
import 'package:intl/intl.dart';
import '../const.dart';
import 'editor_page.dart';

class NotesList extends StatefulWidget {
  final GlobalKey<AnimatedListState> animatedListKey;
  final MapProvider provider;
  final Tween<Offset> offSetTween;
  final GlobalKey<ScaffoldState> keyScaff;
  final ValueNotifier<int> deleteTiming;
  final Timer timer;

  const NotesList({
    Key key,
    @required this.animatedListKey,
    @required this.provider,
    @required this.offSetTween,
    @required this.keyScaff,
    @required this.deleteTiming,
    @required this.timer,
  }) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState(
        animatedListKey,
        provider,
        offSetTween,
        keyScaff,
        deleteTiming,
        timer,
      );
}

class _NotesListState extends State<NotesList> {
  final GlobalKey<AnimatedListState> animatedListKey;
  final MapProvider provider;
  final Tween<Offset> offSetTween;
  final GlobalKey<ScaffoldState> keyScaff;
  final ValueNotifier<int> deleteTiming;
  final Timer timer;

  _NotesListState(
    this.animatedListKey,
    this.provider,
    this.offSetTween,
    this.keyScaff,
    this.deleteTiming,
    this.timer,
  );
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context).textTheme;
    String _date(MyNote _note) {
      return DateFormat().add_yMd().add_Hms().format(DateTime.parse(_note.id));
    }

    void _inkwellOnTap(MyNote _note) {
      if (deleteTiming.value != 10) timer.cancel();
      provider.editingModeFalse();
      Get.to(
        EditorPage(
          id: _note.id,
          title: _note.title,
          content: NotusDocument.fromJson(jsonDecode(_note.content)),
          animatedListKey: animatedListKey,
        ),
      );
    }

    return AnimatedList(
      padding: EdgeInsets.symmetric(vertical: 10),
      key: animatedListKey,
      initialItemCount: provider.noteList.length,
      itemBuilder: (_, i, anim) {
        // ignore: omit_local_variable_types
        MyNote _note = provider.noteList[i];
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: offSetTween.animate(anim),
            child: Card(
              shadowColor: Theme.of(context).cardColor.withOpacity(.5),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 10,
              child: Dismissible(
                dismissThresholds: {
                  DismissDirection.endToStart: 0.5,
                  DismissDirection.startToEnd: 0.5,
                },
                key: UniqueKey(),
                background: Background(false),
                secondaryBackground: Background(true),
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) => _confirmDismiss(i),
                  );
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  radius: 450,
                  onTap: () {
                    _inkwellOnTap(_note);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11.0),
                    child: Column(
                      children: [
                        Text(_note.title, style: _theme.button),
                        SizedBox(height: 6),
                        Text(_date(_note), style: _theme.caption)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AlertDialog _confirmDismiss(int i) {
    return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Intentionally to delete'),
        actions: [
          FlatButton(
            child: Text('Yes', style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.clrAt(i);
              animatedListKey.currentState
                  .removeItem(i, (context, animation) => SizedBox());
              Get.back();
              Get.snackbar('Successfully', 'Note deleted', colorText: white);
            },
          ),
          FlatButton(
            onPressed: Get.back,
            child: Text('No', style: TextStyle(color: Colors.blue)),
          ),
        ],
    );
  }
}

/// used for secondaryBackground?
class Background extends StatelessWidget {
  final bool secondary;

  const Background(this.secondary);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment:
            secondary ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: secondary
                ? const EdgeInsets.only(right: 12)
                : const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.delete_sweep,
              color: Colors.red[800],
            ),
          ),
        ],
      ),
    );
  }
}
