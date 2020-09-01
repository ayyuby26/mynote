import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mynote/model/notes.dart';
import './main_page.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appPath = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  Hive.registerAdapter(NotesAdapter());
  runApp(MyApp());
}

// Create a Focus Intent that does nothing
class FakeFocusIntent extends Intent {
  const FakeFocusIntent();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // disable default arrows focus changes.
      // otherwise it makes the keyboard flicker when we move with arrows)
      shortcuts: Map<LogicalKeySet, Intent>.from(WidgetsApp.defaultShortcuts)
        ..addAll(<LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): const FakeFocusIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const FakeFocusIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const FakeFocusIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const FakeFocusIntent(),
        }),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      title: "My Note",
    );
  }
}
