// ignore_for_file: sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, constant_pattern_never_matches_value_type
import 'dart:convert';
import 'dart:math';
import 'package:arab_wordle_1/keyboard.dart';
import 'package:arab_wordle_1/screens/main_menu.dart';
import 'package:arab_wordle_1/themes/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FiveLetterScreen extends StatefulWidget {
  const FiveLetterScreen({super.key, required this.isHardMode});
  final bool isHardMode;

  @override
  State<StatefulWidget> createState() {
    return _FiveLetterScreen();
  }
}

class _FiveLetterScreen extends State<FiveLetterScreen>
    with TickerProviderStateMixin {
  bool gameWon = false;

  int _currentTextfield = 0;

  int _fiveLettersStop = 0;

  String _correctWord = '';

  int _currentRow = 0;

  final List<TextEditingController> _controllers =
      List.generate(35, (index) => TextEditingController());

  final List<Color> _fillColors =
      List.generate(35, (index) => Colors.transparent);

  final List<String> _colorTypes = List.generate(35, (index) => "surface");

  List<String> words = [];
  List<String> c_words = [];
  List<int> revealedIndices = [];
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

    for (int i = 0; i < 7; i++) {
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

    for (int i = 0; i < 35; i++) {
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
            controller.reverse();
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
    _shakeControllers[_currentRow].forward(from: 0);
  }

  Future<void> _vibrateTwice() async {
    final prefs = await SharedPreferences.getInstance();
    bool isHapticEnabled = prefs.getBool('isHapticEnabled') ?? true;

    if (!isHapticEnabled) return; // Skip if haptic feedback is disabled

    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.lightImpact();
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isHardMode
              ? AppLocalizations.of(context).translate('hard_mode_title')
              : AppLocalizations.of(context).translate('normal_mode_title'),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          GestureDetector(
            child: coins(context, diamondAmount),
            onTap: () {
              openShop(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          for (int i = 0; i < 7; i++)
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
                      for (int j = 4; j >= 0; j--)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 65,
                            width: 65,
                            child: AnimatedBuilder(
                              animation: _scaleAnimations[i * 5 + j],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimations[i * 5 + j].value,
                                  child: child,
                                );
                              },
                              child: TextField(
                                controller: _controllers[i * 5 + j],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                readOnly: _readOnly,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
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
                                  fillColor: _fillColors[i * 5 + j],
                                  filled: true,
                                  counterText: '',
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _revealHint,
                icon: const Icon(Icons.search_rounded),
                iconSize: 40,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
            ],
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
  void _revealHint() {
    int startIndex = _currentRow * 5;
    int endIndex = startIndex + 4;

    List<int> availableIndices = [];

    for (int i = startIndex; i <= endIndex; i++) {
      if (!revealedIndices.contains(i) && _controllers[i].text.isEmpty) {
        availableIndices.add(i);
      }
    }

    if (gameWon == false && availableIndices.isNotEmpty) {
      int randomIndex =
          availableIndices[Random().nextInt(availableIndices.length)];
      String letter = _correctWord[randomIndex % 5];

      setState(() {
        _controllers[randomIndex].text = letter;
        _fillColors[randomIndex] = const Color.fromARGB(122, 158, 158, 158);
        revealedIndices.add(randomIndex);
      });
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    if ((_currentTextfield < 35 && _fiveLettersStop < 5) && gameWon == false) {
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
    if (_currentTextfield % 5 != 0 || _fiveLettersStop != 5) {
      _vibrateTwice();
      _shakeCurrentRow();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 2),
          content: Text(
            AppLocalizations.of(context).translate('five_letter_error'),
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
      _vibrateTwice();
      _shakeCurrentRow();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 2),
          content: Text(
            AppLocalizations.of(context).translate('not_in_library'),
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
          title: Text(
            AppLocalizations.of(context).translate('correct_title'),
            textAlign: TextAlign.center,
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                    text: AppLocalizations.of(context).translate('learn_word'),
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface)),
                TextSpan(
                    text: _correctWord,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

      if (_currentTextfield == 35 && gameWon == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              AppLocalizations.of(context).translate('incorrect'),
              textAlign: TextAlign.center,
            ),
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        AppLocalizations.of(context).translate('correct_word'),
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

    _currentWordList.clear();
    _fiveLettersStop = 0;
    _currentRow++;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
