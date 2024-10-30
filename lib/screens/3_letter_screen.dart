// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:arab_wordle_1/keyboard.dart';
import 'package:arab_wordle_1/themes/theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ThreeLetterScreen extends StatefulWidget {
  const ThreeLetterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FourLetterScreen();
  }
}

class _FourLetterScreen extends State<ThreeLetterScreen>
    with TickerProviderStateMixin {
  bool gameWon = false;

  int _currentTextfield = 0;

  int _fiveLettersStop = 0;

  String _correctWord = '';

  final List<TextEditingController> _controllers =
      List.generate(18, (index) => TextEditingController());

  final List<Color> _fillColors =
      List.generate(18, (index) => Colors.transparent);

  final List<String> _colorTypes = List.generate(18, (index) => "surface");

  List<String> words = [];
  List<String> c_words = [];

  final bool _readOnly = true;

  Map<String, Color> keyColors = {};

  final List<AnimationController> _shakeControllers = [];
  final List<Animation<double>> _shakeAnimations = [];

  final List<AnimationController> _scaleControllers = [];
  final List<Animation<double>> _scaleAnimations = [];

  @override
  void initState() {
    super.initState();
    _loadWordsFromJson();

    for (int i = 0; i < 6; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );

      final animation = Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticIn,
        ),
      );

      _shakeControllers.add(controller);
      _shakeAnimations.add(animation);
    }

    for (int i = 0; i < 18; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );

      final animation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controller.reverse(); // Return to normal size after popping up
          }
        });

      _scaleControllers.add(controller);
      _scaleAnimations.add(animation);
    }
  }

  @override
  void dispose() {
    for (var controller in _shakeControllers) {
      controller.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _shakeCurrentRow() {
    int currentRow = (_currentTextfield / 3).floor();
    _shakeControllers[currentRow].forward(from: 0);
  }

  void _triggerPopUp(int index) {
    if (index >= 0 && index < _scaleControllers.length) {
      _scaleControllers[index].forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFillColors();
    _updateKeyColors();
  }

  Future<void> _loadWordsFromJson() async {
    final jsonString = await rootBundle
        .loadString('assets/words/3_letters/3_letter_words_all.json');

    final jsonString2 = await rootBundle
        .loadString('assets/words/3_letters/3_letter_answers.json');

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
            AnimatedBuilder(
              animation: _shakeAnimations[i],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      _shakeAnimations[i].value *
                          sin(_shakeControllers[i].value * 2 * pi),
                      0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int j = 2; j >= 0; j--)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: 90,
                            width: 60,
                            child: AnimatedBuilder(
                              animation: _scaleAnimations[i * 3 + j],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimations[i * 3 + j].value,
                                  child: child,
                                );
                              },
                              child: TextField(
                                controller: _controllers[i * 3 + j],
                                readOnly: _readOnly,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  fillColor: _fillColors[i * 3 + j],
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
                        ),
                    ],
                  ),
                );
              },
            ),
          CustomKeyboard(
            onTextInput: (myText) => _insertText(myText),
            onBackspace: _backspace,
            onSubmit: _submit,
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
    if ((_currentTextfield < 18 && _fiveLettersStop < 3) && gameWon == false) {
      final controller = _controllers[_currentTextfield];

      controller.text = myText;

      setState(() {
        _triggerPopUp(_currentTextfield);
        _currentTextfield++;
        _fiveLettersStop++;
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
    if (_currentTextfield % 3 != 0 || _fiveLettersStop != 3) {
      _shakeCurrentRow();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 2),
          content: Text(
            "الرجاء إدخال كلمة تتكون من 3 أحرف",
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

    List<String> currentWordList = [];
    String currentWord = "";
    String guessedLetter;

    int startIndex = _currentTextfield - 3;
    int endIndex = _currentTextfield - 1;

    List<String> deconstructedCorrectWord = _correctWord.split('');
    Map<String, int> letterCounts = {};

    for (var letter in deconstructedCorrectWord) {
      letterCounts[letter] = (letterCounts[letter] ?? 0) + 1;
    }

    for (int i = startIndex; i <= endIndex; i++) {
      currentWordList.add(_controllers[i].text);
    }

    currentWord = currentWordList.join("");

    if (!words.contains(currentWord)) {
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

    if (currentWord == _correctWord) {
      setState(() {
        for (int k = startIndex; k <= endIndex; k++) {
          guessedLetter = _controllers[k].text;
          _fillColors[k] = Theme.of(context).colorScheme.onPrimary;
          keyColors[guessedLetter] = Theme.of(context).colorScheme.onPrimary;
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
        guessedLetter = _controllers[i].text;

        if (guessedLetter == deconstructedCorrectWord[j]) {
          setState(() {
            _fillColors[i] = Theme.of(context).colorScheme.onPrimary;
            keyColors[guessedLetter] = Theme.of(context).colorScheme.onPrimary;
            _colorTypes[i] = "onPrimary";
          });
          letterCounts[guessedLetter] = letterCounts[guessedLetter]! - 1;
        }
      }

      for (int i = startIndex, j = 0; i <= endIndex; i++, j++) {
        guessedLetter = _controllers[i].text;
        if (_fillColors[i] != Theme.of(context).colorScheme.onPrimary) {
          if (letterCounts.containsKey(guessedLetter) &&
              letterCounts[guessedLetter]! > 0) {
            setState(() {
              _fillColors[i] = Theme.of(context).colorScheme.onSecondary;
              _colorTypes[i] = "onSecondary";
            });
            letterCounts[guessedLetter] = letterCounts[guessedLetter]! - 1;

            if (keyColors[guessedLetter] !=
                Theme.of(context).colorScheme.onPrimary) {
              setState(() {
                keyColors[guessedLetter] =
                    Theme.of(context).colorScheme.onSecondary;
              });
            }
          } else {
            setState(() {
              _fillColors[i] = Theme.of(context).colorScheme.onError;
              _colorTypes[i] = "onError";
            });
            if (keyColors[guessedLetter] !=
                    Theme.of(context).colorScheme.onPrimary &&
                keyColors[guessedLetter] !=
                    Theme.of(context).colorScheme.onSecondary) {
              keyColors[guessedLetter] = Theme.of(context).colorScheme.onError;
            }
          }
        }
      }

      if (_currentTextfield == 18 && gameWon == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text(
              'كشل',
              textAlign: TextAlign.center,
            ),
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'الكلمة الصحيحة هي: ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
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
      } else if (gameWon == true) {}
    }

    currentWordList.clear();
    _fiveLettersStop = 0;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
