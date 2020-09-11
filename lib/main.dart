import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mynote/core/viewmodels/map_provider.dart';
import 'package:provider/provider.dart';
import 'const.dart';
import 'package:flutter/material.dart';
import 'ui/main_page.dart';
void main() async {
  await GetStorage.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MapProvider()),
  ], child: MyApp()));
}

// Create a Focus Intent that does nothing
class FakeFocusIntent extends Intent {
  const FakeFocusIntent();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [],
        theme: themeData,
        home: MaterialApp(
            theme: themeData,
            title: 'MyNote',
            // disable default arrows focus changes.
            // otherwise it makes the keyboard flicker when we move with arrows)
            shortcuts: shortcutsData,
            debugShowCheckedModeBanner: false,
            home: MainPage()),
    );
  }
}
