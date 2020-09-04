part of 'notes_cubit.dart';

abstract class NotesState extends Equatable {}

class NotesInitial extends NotesState {
  final List<MyNote> notesBox;
  final int deleteTiming;
  final bool editingMode;

  NotesInitial({this.editingMode, this.deleteTiming, this.notesBox});

  @override
  List get props => [notesBox, deleteTiming, editingMode];
}
