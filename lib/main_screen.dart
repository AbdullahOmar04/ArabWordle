// ignore_for_file: sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable
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
  int _currentTextfield = 24;

  int _currentRow = 0;

  final String _corectWord = 'إنتحر';

  final List<TextEditingController> _controllers =
      List.generate(25, (index) => TextEditingController());

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
          for (int i = 0; i < 5; i++) // 6 rows of 5 TextFields each
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 4; j >= 0; j--) // 5 TextFields per row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 100,
                      width: 60,
                      child: TextField(
                        controller: _controllers[(4 - i) * 5 + (4 - j)],
                        readOnly: _readOnly,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade400,
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
    if (_currentTextfield >= 0 && _currentRow < 5) {
      final controller = _controllers[_currentTextfield];

      controller.text = myText;

      setState(() {
        if (_currentTextfield > 0) {
          _currentTextfield--;
          _currentRow++;
        }
      });
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _backspace() {
    if (_currentTextfield > 0 && _currentRow > 0) {
      setState(() {
        _currentTextfield++;
        _currentRow--;
      });

      _controllers[_currentTextfield].clear();
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _submit() {
    List<String> _currentWordList = [];
    String _currentWord = "";
    String _guessedLetter;
    String _correctLetter;

    int startIndex = _currentTextfield + 5;
    int endIndex = _currentTextfield;

    List<String> _deconstructedCorrectWord = _corectWord.split('');

    if (_currentRow == 5) {
      for (int i = startIndex; i >= endIndex; i--) {
        _currentWordList.add(_controllers[i].text);
      }

      _currentWord = _currentWordList.join("");
      print(_currentWord);

      if (_currentWord == _corectWord) {
        setState(() {
          print("correct word");
          _currentRow = 0;
        });
      } else {
        for (int i = startIndex; i > endIndex; i--) {
          for (int j = 0; j < 5; j++) {
            _guessedLetter = _controllers[i].text;
            _correctLetter = _deconstructedCorrectWord[j];

            if (_guessedLetter == _correctLetter && _currentWordList[j] == _deconstructedCorrectWord[j]) {
              print(
                  "The letter $_guessedLetter and $_correctLetter are identitcal and in the same position");
            } else if (_guessedLetter == _correctLetter && _currentWordList[j] != _deconstructedCorrectWord[j]) {
              print(
                  "The letter $_guessedLetter and $_correctLetter are identitcal but not in the correct position");
            } else {
              print(
                  "The letter $_guessedLetter and $_correctLetter are NOT identitcal");
            }
          }
        }
        setState(() {
          print("Wrong word");
          _currentRow = 0;
        });
      }

      _currentWordList.clear();
    } else {
      print("Only 5 letter words");
    }
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
