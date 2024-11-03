import 'package:arab_wordle_1/screens/3_letter_screen.dart';
import 'package:arab_wordle_1/screens/4_letter_screen.dart';
import 'package:arab_wordle_1/screens/5_letter_screen.dart';
import 'package:arab_wordle_1/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isHardMode = false; // Track the hard mode state

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/Mountains.png', // Path to your logo
                height: 200,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  activeColor: Colors.red,
                  value: isHardMode,
                  onChanged: (value) {
                    setState(() {
                      isHardMode = value; // Toggle hard mode on/off
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  "المستوى الصعب",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mode Selection Buttons
            _buildModeButton(
                context, 'وضع ٣ أحرف', Theme.of(context).colorScheme.secondary,
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ThreeLetterScreen(isHardMode: isHardMode),
                  ) // Pass hard mode state
                  );
            }),
            const SizedBox(height: 20),
            _buildModeButton(
                context, 'وضع ٤ أحرف', Theme.of(context).colorScheme.secondary,
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FourLetterScreen(isHardMode: isHardMode),
                  ) // Pass hard mode state
                  );
            }),
            const SizedBox(height: 20),
            _buildModeButton(
                context, 'وضع ٥ أحرف', Theme.of(context).colorScheme.secondary,
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FiveLetterScreen(isHardMode: isHardMode),
                  ) // Pass hard mode state
                  );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _settings(context, themeNotifier);
                  },
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.question_mark_rounded),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  void _settings(BuildContext context, ThemeNotifier themeNotifier) async {
    ThemeMode selectedThemeMode = themeNotifier.themeMode;
    final prefs = await SharedPreferences.getInstance();
    bool isHapticEnabled = prefs.getBool('isHapticEnabled') ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              'الإعدادات',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'تمكين الاهتزاز',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  trailing: Switch(
                    value: isHapticEnabled,
                    onChanged: (bool value) async {
                      setState(() {
                        isHapticEnabled = value;
                      });
                      await prefs.setBool('isHapticEnabled', isHapticEnabled);
                      print('Haptic feedback set to: $isHapticEnabled');
                    },
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'وضع التطبيق',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 30,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioListTile<ThemeMode>(
                                  title: const Text('الوضع الليلي'),
                                  value: ThemeMode.dark,
                                  groupValue: selectedThemeMode,
                                  onChanged: (ThemeMode? value) {
                                    setState(() {
                                      selectedThemeMode = value!;
                                      themeNotifier.setTheme(selectedThemeMode);
                                    });
                                  }),
                              RadioListTile<ThemeMode>(
                                title: const Text('الوضع الصباحي'),
                                value: ThemeMode.light,
                                groupValue: themeNotifier.themeMode,
                                onChanged: (ThemeMode? value) {
                                  setState(() {
                                    selectedThemeMode = value!;
                                    themeNotifier.setTheme(selectedThemeMode);
                                  });
                                },
                              ),
                              RadioListTile<ThemeMode>(
                                title: const Text('اعداد النظام'),
                                value: ThemeMode.system,
                                groupValue: themeNotifier.themeMode,
                                onChanged: (ThemeMode? value) {
                                  selectedThemeMode = value!;
                                  themeNotifier.setTheme(selectedThemeMode);
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'إغلاق',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('اختر السمة'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
