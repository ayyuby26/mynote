import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mynote/cubit/notes_cubit/notes_cubit.dart';
import 'package:zefyr/zefyr.dart';
import 'model/notes.dart';
import 'editor_page.dart';

// ignore: must_be_immutable
class NotesList extends StatelessWidget {
  final GlobalKey<AnimatedListState> animatedListKey;
  final Tween<Offset> offSetTween;
  final GlobalKey<ScaffoldState> keyScaff;

  NotesList({
    @required this.animatedListKey,
    @required this.offSetTween,
    @required this.keyScaff,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        final List<MyNote> notes = state.props[0];
        final int _deleteTiming = state.props[1];
        final NotesCubit _notesCubit = context.bloc<NotesCubit>();
        if (notes == null)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 200,
                    child: SvgPicture.asset("assets/pict/empty.svg")),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "No Notes ",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          );
        else
          return AnimatedList(
              padding: EdgeInsets.symmetric(vertical: 10),
              key: animatedListKey,
              initialItemCount: notes.length,
              itemBuilder: (_, i, anim) {
                MyNote note = notes[i];
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
                        background: Container(
                          decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(5)),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.red[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.red[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (v) async {
                          if (_deleteTiming != 10) {
                            keyScaff.currentState.hideCurrentSnackBar();
                            await Future.delayed(Duration(milliseconds: 100));
                            _notesCubit.timerCancel();
                          }
                          List f = [];
                          f.add(note);
                          _notesCubit.startTimer();

                          // ignore: todo

                          Get.snackbar("title",
                              "${note.title} will be deleted, under $_deleteTiming",
                              mainButton: FlatButton(
                                  onPressed: () {
                                    keyScaff.currentState.hideCurrentSnackBar();
                                    notes.add(f[0]);
                                    animatedListKey.currentState.insertItem(i);
                                  },
                                  child: Text("cancel")),
                              animationDuration: Duration(seconds: 10));
                          // keyScaff.currentState.showSnackBar(SnackBar(
                          //   behavior: SnackBarBehavior.floating,
                          //   duration: Duration(seconds: 10),
                          //   content: Text(
                          //     "${note.title} will be deleted, under ",
                          //   ),
                          //   action: SnackBarAction(
                          //       label: "cancel",
                          //       onPressed: () {
                          //         keyScaff.currentState.hideCurrentSnackBar();
                          //         state.add(f[0]);

                          //         animatedListKey.currentState.insertItem(i);
                          //       }),
                          // ));
                          _notesCubit.timerSetDuration();
                          _notesCubit.clrAt(i);
                          animatedListKey.currentState.removeItem(
                              i, (context, animation) => SizedBox());
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          radius: 450,
                          onTap: () async {
                            if (_deleteTiming != 10) {
                              keyScaff.currentState.hideCurrentSnackBar();
                              _notesCubit.timerCancel();
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditorPage(
                                          id: note.id,
                                          title: note.title,
                                          content: NotusDocument.fromJson(
                                            jsonDecode(note.content),
                                          ),
                                          animatedListKey: animatedListKey,
                                          list: notes,
                                        )));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(11.0),
                            child: Column(
                              children: [
                                Text(
                                  note.title,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                    DateFormat()
                                        .add_yMd()
                                        .add_Hms()
                                        .format(DateTime.parse(note.id)),
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });

        // print(state.isNullOrBlank);
        // return Center(
        //   child: Text("ada masalah"),
        // );
      },
    );
  }
}
