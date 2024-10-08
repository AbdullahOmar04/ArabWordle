// ignore_for_file: sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, constant_pattern_never_matches_value_type
import 'dart:convert';
import 'dart:math';

import 'package:arab_wordle_1/keyboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

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

  final List<TextEditingController> _controllers =
      List.generate(30, (index) => TextEditingController());

  final List<Color> _fillColors =
      List.generate(30, (index) => Colors.grey.shade300);

  List<String> words = [];

  final bool _readOnly = true;

  Map<String, Color> keyColors = {};

  Future<void> _loadWordsFromJson() async {
    final jsonString =
        await rootBundle.loadString('assets/filtered_words.json');

    final data = json.decode(jsonString);

    setState(() {
      words = List<String>.from(data['words']);
    });

    _getRandomWord(words);
  }

  void _getRandomWord(List<String> words) {
    final random = Random();
    setState(() {
      _correctWord = words[random.nextInt(words.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ووردل",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        backgroundColor: Colors.grey.shade800,
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
                          fillColor: _fillColors[i * 5 + j],
                          filled: true,
                          counterText: '',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
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
    if (_currentTextfield % 5 != 0 || _fiveLettersStop != 5) {
      print("Please enter a 5-letter word");
      return;
    }

    List<String> _currentWordList = [];
    String _currentWord = "";
    String _guessedLetter;

    int startIndex = _currentTextfield - 5;
    int endIndex = _currentTextfield - 1;

    List<String> _deconstructedCorrectWord = _correctWord.split('');
    Map<String, int> letterCounts = {};

    // Count occurrences of each letter in the correct word
    for (var letter in _deconstructedCorrectWord) {
      letterCounts[letter] = (letterCounts[letter] ?? 0) + 1;
    }

    for (int i = startIndex; i <= endIndex; i++) {
      _currentWordList.add(_controllers[i].text);
    }

    _currentWord = _currentWordList.join("");

    if (!words.contains(_currentWord)) {
      SnackBar(
        content: const Text("Words not in list"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20),
      );
      return;
    }

    if (_currentWord == _correctWord) {
      setState(() {
        for (int k = startIndex; k <= endIndex; k++) {
          _fillColors[k] = Colors.green;
        }
        print("correct word");
        gameWon = true;
      });
    } else {
      for (int i = startIndex, j = 0; i <= endIndex; i++, j++) {
        _guessedLetter = _controllers[i].text;

        if (_guessedLetter == _deconstructedCorrectWord[j]) {
          setState(() {
            _fillColors[i] = Colors.green;
            keyColors[_guessedLetter] = Colors.green;
          });
          letterCounts[_guessedLetter] = letterCounts[_guessedLetter]! - 1;
        }
      }

      for (int i = startIndex, j = 0; i <= endIndex; i++, j++) {
        _guessedLetter = _controllers[i].text;
        if (_fillColors[i] != Colors.green) {
          if (letterCounts.containsKey(_guessedLetter) &&
              letterCounts[_guessedLetter]! > 0) {
            setState(() {
              _fillColors[i] = Colors.orange;
            });
            letterCounts[_guessedLetter] = letterCounts[_guessedLetter]! - 1;

            if (keyColors[_guessedLetter] != Colors.green) {
              setState(() {
                keyColors[_guessedLetter] = Colors.orange;
              });
            }
          } else {
            setState(() {
              _fillColors[i] = Colors.grey.shade600;
            });
            if (keyColors[_guessedLetter] != Colors.green &&
                keyColors[_guessedLetter] != Colors.orange) {
              keyColors[_guessedLetter] = Colors.grey.shade600;
            }
          }
        }
      }
      if (_currentTextfield == 30 && gameWon == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey.shade700,
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
