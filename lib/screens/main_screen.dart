// ignore_for_file: sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, constant_pattern_never_matches_value_type
import 'dart:convert';
import 'dart:math';

import 'package:arab_wordle_1/keyboard.dart';
import 'package:arab_wordle_1/screens/3_letter_screen.dart';
import 'package:arab_wordle_1/screens/4_letter_screen.dart';
import 'package:arab_wordle_1/themes/theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  bool gameWon = false;

  int _currentTextfield = 0;

  int _fiveLettersStop = 0;

  String _correctWord = '';

  @override
  void initState() {
    super.initState();
    _loadWordsFromJson();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFillColors();
    _updateKeyColors();
  }

  final List<TextEditingController> _controllers =
      List.generate(30, (index) => TextEditingController());

  final List<Color> _fillColors =
      List.generate(30, (index) => Colors.transparent);

  final List<String> _colorTypes = List.generate(30, (index) => "surface");

  List<String> words = [];
  List<String> c_words = [];

  final bool _readOnly = true;

  Map<String, Color> keyColors = {};

  Future<void> _loadWordsFromJson() async {
    final jsonString = await rootBundle
        .loadString('assets/words/5_letters/5_letter_words_all.json');

    final jsonString2 = await rootBundle
        .loadString('assets/words/5_letters/5_letter_answers.json');

    final data = json.decode(jsonString);
    final data2 = json.decode(jsonString2);

    setState(() {
      words = List<String>.from(data['words']);
      c_words = List<String>.from(data2['c_words']);
    });

    _getRandomWord(c_words);
  }

  void _getRandomWord(List<String> woords) {
    final random = Random();
    setState(() {
      _correctWord = c_words[random.nextInt(woords.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Mountains.png'),
                ),
              ),
              child: null,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ListTile(
                title: const Text(
                  '٣  أحرف',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                tileColor: Theme.of(context).colorScheme.primary,
                shape: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ThreeLetterScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ListTile(
                title: const Text(
                  '٤ أحرف',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                tileColor: Theme.of(context).colorScheme.primary,
                shape: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const FourLetterScreen();
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ووردل",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              ThemeNotifier themeNotifier =
                  Provider.of<ThemeNotifier>(context, listen: false);
              if (themeNotifier.themeMode == ThemeMode.light) {
                themeNotifier.setTheme(ThemeMode.dark);
              } else {
                themeNotifier.setTheme(ThemeMode.light);
              }
              _updateFillColors();
              _updateKeyColors();
            },
            icon: Icon(
                Provider.of<ThemeNotifier>(context).themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode_rounded),
            color: Theme.of(context).colorScheme.onSurface,
            iconSize: 30,
            padding: const EdgeInsets.only(right: 10),
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          for (int i = 0; i < 6; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 4; j >= 0; j--)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 90,
                      width: 60,
                      child: TextField(
                        controller: _controllers[i * 5 + j],
                        readOnly: _readOnly,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          fillColor: _fillColors[i * 5 + j],
                          filled: true,
                          counterText: '',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(width: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          CustomKeyboard(
            onTextInput: (myText) {
              _insertText(myText);
            },
            onBackspace: () {
              _backspace();
            },
            onSubmit: () {
              _submit();
            },
            keyColors: keyColors,
          ),
        ],
      ),
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _updateFillColors() {
    setState(() {
      final colorScheme = Theme.of(context).colorScheme;

      for (int i = 0; i < _fillColors.length; i++) {
        switch (_colorTypes[i]) {
          case "onPrimary":
            _fillColors[i] = colorScheme.onPrimary;
            break;
          case "onSecondary":
            _fillColors[i] = colorScheme.onSecondary;
            break;
          case "onError":
            _fillColors[i] = colorScheme.onError;
            break;
          default:
            _fillColors[i] = Colors.transparent;
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _updateKeyColors() {
    setState(() {
      keyColors.clear();
      final colorScheme = Theme.of(context).colorScheme;

      for (int i = 0; i < _currentTextfield; i++) {
        String letter = _controllers[i].text;

        if (letter.isEmpty) continue;

        Color keyColor;
        switch (_colorTypes[i]) {
          case "onPrimary":
            keyColor = colorScheme.onPrimary;
            break;
          case "onSecondary":
            keyColor = colorScheme.onSecondary;
            break;
          case "onError":
            keyColor = colorScheme.onError;
            break;
          default:
            keyColor = Theme.of(context).colorScheme.primary;
        }

        keyColors[letter] = keyColor;
      }
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _insertText(String myText) {
    if ((_currentTextfield < 30 && _fiveLettersStop < 5) && gameWon == false) {
      final controller = _controllers[_currentTextfield];

      controller.text = myText;

      setState(() {
        _currentTextfield++;
        _fiveLettersStop++;

        print("textfield = $_currentTextfield");
      });
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _backspace() {
    if ((_currentTextfield > 0 && _fiveLettersStop > 0) && gameWon == false) {
      setState(() {
        _currentTextfield--;
        _fiveLettersStop--;
      });

      _controllers[_currentTextfield].clear();
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _submit() {
    print(_correctWord);
    if (_currentTextfield % 5 != 0 || _fiveLettersStop != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 2),
          content: Text(
            "الرجاء إدخال كلمة تتكون من 5 أحرف",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20,
          ),
        ),
      );

      return;
    }

    List<String> _currentWordList = [];
    String _currentWord = "";
    String _guessedLetter;

    int startIndex = _currentTextfield - 5;
    int endIndex = _currentTextfield - 1;

    List<String> _deconstructedCorrectWord = _correctWord.split('');
    Map<String, int> letterCounts = {};

    for (var letter in _deconstructedCorrectWord) {
      letterCounts[letter] = (letterCounts[letter] ?? 0) + 1;
    }

    for (int i = startIndex; i <= endIndex; i++) {
      _currentWordList.add(_controllers[i].text);
    }

    _currentWord = _currentWordList.join("");

    if (!words.contains(_currentWord)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 2),
          content: Text(
            "الكلمة ليست في قاموس اللعبة",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20,
          ),
        ),
      );

      return;
    }

    if (_currentWord == _correctWord) {
      setState(() {
        for (int k = startIndex; k <= endIndex; k++) {
          _guessedLetter = _controllers[k].text;
          _fillColors[k] = Theme.of(context).colorScheme.onPrimary;
          keyColors[_guessedLetter] = Theme.of(context).colorScheme.onPrimary;
          _colorTypes[k] = "onPrimary";
        }
        gameWon = true;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text(
            '!أحسنت',
            textAlign: TextAlign.center,
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: ' تعرف على معنى كلمة',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface)),
                TextSpan(
                    text: _correctWord,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue.shade300),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(
                            'https://www.almaany.com/ar/dict/ar-ar/$_correctWord/?'));
                      }),
              ],
            ),
          ),
        ),
      );
    } else {
      for (int i = startIndex, j = 0; i <= endIndex; i++, j++) {
        _guessedLetter = _controllers[i].text;

        if (_guessedLetter == _deconstructedCorrectWord[j]) {
          setState(() {
            _fillColors[i] = Theme.of(context).colorScheme.onPrimary;
            keyColors[_guessedLetter] = Theme.of(context).colorScheme.onPrimary;
            _colorTypes[i] = "onPrimary";
          });
          letterCounts[_guessedLetter] = letterCounts[_guessedLetter]! - 1;
        }
      }

      for (int i = startIndex, j = 0; i <= endIndex; i++, j++) {
        _guessedLetter = _controllers[i].text;
        if (_fillColors[i] != Theme.of(context).colorScheme.onPrimary) {
          if (letterCounts.containsKey(_guessedLetter) &&
              letterCounts[_guessedLetter]! > 0) {
            setState(() {
              _fillColors[i] = Theme.of(context).colorScheme.onSecondary;
              _colorTypes[i] = "onSecondary";
            });
            letterCounts[_guessedLetter] = letterCounts[_guessedLetter]! - 1;

            if (keyColors[_guessedLetter] !=
                Theme.of(context).colorScheme.onPrimary) {
              setState(() {
                keyColors[_guessedLetter] =
                    Theme.of(context).colorScheme.onSecondary;
              });
            }
          } else {
            setState(() {
              _fillColors[i] = Theme.of(context).colorScheme.onError;
              _colorTypes[i] = "onError";
            });
            if (keyColors[_guessedLetter] !=
                    Theme.of(context).colorScheme.onPrimary &&
                keyColors[_guessedLetter] !=
                    Theme.of(context).colorScheme.onSecondary) {
              keyColors[_guessedLetter] = Theme.of(context).colorScheme.onError;
            }
          }
        }
      }

      if (_currentTextfield == 30 && gameWon == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text(
              'كشل',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'الكلمة الصحيحة هي: '),
                  TextSpan(
                    text: _correctWord,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (gameWon == true) {}
    }

    _currentWordList.clear();
    _fiveLettersStop = 0;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}