import 'package:arab_wordle_1/screens/3_letter_screen.dart';
import 'package:arab_wordle_1/screens/4_letter_screen.dart';
import 'package:arab_wordle_1/screens/5_letter_screen.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isHardMode = false; // Track the hard mode state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/Mountains.png', // Path to your logo
                height: 200,
              ),
            ),

            // Hard Mode Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Hard Mode"),
                Switch(
                  value: isHardMode,
                  onChanged: (value) {
                    setState(() {
                      isHardMode = value; // Toggle hard mode on/off
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mode Selection Buttons
            _buildModeButton(context, '3-Letter Mode', Colors.blue, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ThreeLetterScreen(isHardMode: isHardMode),
                  ) // Pass hard mode state
                  );
            }),
            const SizedBox(height: 20),
            _buildModeButton(context, '4-Letter Mode', Colors.green, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FourLetterScreen(isHardMode: isHardMode),
                  ) // Pass hard mode state
                  );
            }),
            const SizedBox(height: 20),
            _buildModeButton(context, '5-Letter Mode', Colors.purple, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FiveLetterScreen(isHardMode: isHardMode),
                  ) // Pass hard mode state
                  );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
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
}
