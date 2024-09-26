// ignore_for_file: sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, constant_pattern_never_matches_value_type
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

  final String _correctWord = 'عبالي';

  final List<TextEditingController> _controllers =
      List.generate(25, (index) => TextEditingController());

  final List<Color> _fillColors =
      List.generate(25, (index) => Colors.grey.shade300);

  final bool _readOnly = true;

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
          const SizedBox(height: 20),
          for (int i = 0; i < 5; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 4; j >= 0; j--)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 100,
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
          const Spacer(),
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
          ),
        ],
      ),
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _insertText(String myText) {
    if ((_currentTextfield < 25 && _fiveLettersStop < 5) && gameWon == false) {
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
    bool _letterCorrect = false;
    bool _letterFound = false;

    int startIndex = _currentTextfield - 5;
    int endIndex = _currentTextfield - 1;

    List<String> _deconstructedCorrectWord = _correctWord.split('');

    for (int i = startIndex; i <= endIndex; i++) {
      _currentWordList.add(_controllers[i].text);
    }

    _currentWord = _currentWordList.join("");
    print(_currentWord);

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

        if (_deconstructedCorrectWord.contains(_guessedLetter)) {
          setState(() {
            print('$_guessedLetter =  LETTER FOUND IS $_letterFound');
            _letterFound = true;
          });
        }

        if (_guessedLetter == _deconstructedCorrectWord[j]) {
          setState(() {
            _fillColors[i] = Colors.green;
            print('in first IF and letter is $_guessedLetter');
          });
        } else if (_deconstructedCorrectWord.contains(_guessedLetter) &&
            _letterFound == false) {
          setState(() {
            _fillColors[i] = Colors.orange;
            print('in ORANGE and letter is $_guessedLetter');
          });
        } else {
          setState(() {
            _fillColors[i] = Colors.grey.shade600;
            print('letter $_guessedLetter wrong');
          });
        }
      }

      if (_currentTextfield == 25 && gameWon == false) {
        print("Game over. The correct word was: $_correctWord");
      }
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
