import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mynote/cubit/notes_cubit/notes_cubit.dart';
import 'const.dart';
import 'package:flutter/material.dart';
import './main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  runApp(MyApp());
}

// Create a Focus Intent that does nothing
class FakeFocusIntent extends Intent {
  const FakeFocusIntent();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesCubit()),
      ],
      child: GetMaterialApp(
        theme: themeData,
        home: MaterialApp(
            theme: themeData,
            title: "MyNote",
            // disable default arrows focus changes.
            // otherwise it makes the keyboard flicker when we move with arrows)
            shortcuts: shortcutsData,
            debugShowCheckedModeBanner: false,
            home: MainPage()),
      ),
    );
  }
}
