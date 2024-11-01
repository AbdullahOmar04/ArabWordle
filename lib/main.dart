import 'package:arab_wordle_1/screens/main_menu.dart';
import 'package:arab_wordle_1/themes/theme_provider.dart';
import 'package:arab_wordle_1/themes/themes.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          home: const MainMenu(),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
        );
      },
    );
  }
  
}
