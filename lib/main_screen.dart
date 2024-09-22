// ignore_for_file: sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers
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

    // Calculate the starting index for the current row (right-to-left)
    int startIndex = _currentTextfield - (_currentTextfield % 5);
    int endIndex = startIndex + 4;

    // Collect the letters from the current row, reading right to left
    for (int i = endIndex; i >= startIndex; i--) {
      _currentWordList.add(_controllers[i].text);
    }

    _currentWord = _currentWordList.join("");
    print(_currentWord); // For debugging

    // Check if the word matches the correct word and reset row or perform other actions
    if (_currentWord == _corectWord) {
      setState(() {
        _currentRow = 0;
        _currentTextfield = 24; // Reset to the top-right field for a new round
      });
    } else {
      // Move to the next row for a new guess
      setState(() {
        _currentTextfield -= 5; // Jump to the start of the next row
      });
    }

    _currentWordList.clear(); // Clear the list for the next guess
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
