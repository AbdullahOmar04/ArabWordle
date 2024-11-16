import 'package:arab_wordle_1/main.dart';
import 'package:arab_wordle_1/screens/3_letter_screen.dart';
import 'package:arab_wordle_1/screens/4_letter_screen.dart';
import 'package:arab_wordle_1/screens/5_letter_screen.dart';
import 'package:arab_wordle_1/screens/daily_word.dart';
import 'package:arab_wordle_1/themes/app_localization.dart';
import 'package:arab_wordle_1/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int diamondAmount = 0;

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isHardMode = false;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: coins(context, diamondAmount),
            onTap: () {
              openShop(context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/Mountains.png', // Logo
                height: 200,
              ),
            ),

            /*Row(
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
                Text(
                  AppLocalizations.of(context).translate('hard_mode'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),*/
            _longBuildModeButton(
                context,
                AppLocalizations.of(context).translate('daily_mode'),
                Colors.green.shade300,
                Colors.teal.shade300, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DailyMode(),
                ),
              );
            }),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildModeButton(
                      context,
                      AppLocalizations.of(context).translate('5_letter_mode'),
                      const Color.fromARGB(255, 115, 194, 228),
                      const Color.fromARGB(255, 27, 138, 185), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FiveLetterScreen(isHardMode: isHardMode),
                        ) // Pass hard mode state
                        );
                  }),
                  const SizedBox(width: 5),
                  _buildModeButton(
                      context,
                      AppLocalizations.of(context).translate('4_letter_mode'),
                      const Color.fromARGB(255, 255, 187, 86),
                      const Color.fromARGB(255, 255, 126, 39), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FourLetterScreen(isHardMode: isHardMode),
                        ) // Pass hard mode state
                        );
                  }),
                  const SizedBox(width: 5),
                  _buildModeButton(
                      context,
                      AppLocalizations.of(context).translate('3_letter_mode'),
                      const Color.fromARGB(255, 204, 93, 255),
                      const Color.fromARGB(255, 104, 8, 148), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ThreeLetterScreen(isHardMode: isHardMode),
                        ) // Pass hard mode state
                        );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _smallButton(
                  context,
                  const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  Colors.grey,
                  Colors.grey.shade700,
                  () => _settings(context, themeNotifier),
                ),
                const SizedBox(width: 5),
                _smallButton(
                  context,
                  const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                  ),
                  const Color.fromARGB(255, 255, 111, 101),
                  const Color.fromARGB(255, 255, 47, 32),
                  () => openShop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _longBuildModeButton(BuildContext context, String text,
      Color gradStart, Color gradEnd, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: const Size.fromHeight(120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 56,
                  color: Colors.white,
                ), // Base icon
                Positioned(
                  top: 18,
                  child: Text(
                    '${DateTime.now().day}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            title: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, String text, Color gradStart,
      Color gradEnd, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradStart, gradEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallButton(BuildContext context, Icon icon, Color gradStart,
      Color gradEnd, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: icon,
      ),
    );
  }

  void _settings(BuildContext context, ThemeNotifier themeNotifier) async {
    int selectedIndex =
        Localizations.localeOf(context).languageCode == 'ar' ? 1 : 0;
    ThemeMode selectedThemeMode = themeNotifier.themeMode;
    final prefs = await SharedPreferences.getInstance();
    bool isHapticEnabled = prefs.getBool('isHapticEnabled') ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate('settings'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).translate('choose_lang'),
                ),
                const SizedBox(height: 12),
                ToggleButtons(
                  isSelected: [selectedIndex == 0, selectedIndex == 1],
                  onPressed: (index) {
                    setState(() {
                      selectedIndex = index;
                      if (index == 0) {
                        MyApp.setLocale(context, const Locale('en', 'US'));
                      } else {
                        MyApp.setLocale(context, const Locale('ar', 'SA'));
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  selectedBorderColor: Theme.of(context).colorScheme.primary,
                  color: Theme.of(context).colorScheme.onSurface,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('En'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Ar'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context).translate('enable_vibration'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18),
                  ),
                  trailing: Switch(
                    activeColor: Theme.of(context).colorScheme.onSurface,
                    value: isHapticEnabled,
                    onChanged: (bool value) async {
                      setState(() {
                        isHapticEnabled = value;
                      });
                      await prefs.setBool('isHapticEnabled', isHapticEnabled);
                    },
                  ),
                ),
                Divider(
                  height: 30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            AppLocalizations.of(context).translate('app_mode'),
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
                                  title: Text(AppLocalizations.of(context)
                                      .translate('dark_mode')),
                                  value: ThemeMode.dark,
                                  groupValue: selectedThemeMode,
                                  onChanged: (ThemeMode? value) {
                                    setState(() {
                                      selectedThemeMode = value!;
                                      themeNotifier.setTheme(selectedThemeMode);
                                    });
                                  }),
                              RadioListTile<ThemeMode>(
                                title: Text(AppLocalizations.of(context)
                                    .translate('light_mode')),
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
                                title: Text(AppLocalizations.of(context)
                                    .translate('system_mode')),
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
                              child: Text(
                                AppLocalizations.of(context).translate('close'),
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('choose_theme'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context).translate('close'),
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget coins(BuildContext context, int amount) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(94, 131, 131, 131),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      border:
          Border.all(width: 5, color: Theme.of(context).colorScheme.surface),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.diamond,
          color: Colors.blue,
        ),
        const SizedBox(width: 10),
        Text(
          '$amount',
          style: const TextStyle(fontSize: 15),
        ),
      ],
    ),
  );
}

void openShop(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('shop'),
        ),
      );
    },
  );
}
