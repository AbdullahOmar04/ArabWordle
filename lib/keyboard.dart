import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onSubmit,
    required this.keyColors,
  });

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;
  final Map<String, Color> keyColors;

  void _textInputHandler(String text) => onTextInput.call(text);

  void _backspaceHandler() => onBackspace.call();

  void _submitHandler() => onSubmit.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 238.7,
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      color: Colors.grey.shade800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildRowOne(), buildRowTwo(), buildRowThree()],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          'ض',
          'ص',
          'ث',
          'ق',
          'ف',
          'غ',
          'ع',
          'ه',
          'خ',
          'ح',
          'ج',
          'إ',
        ]
            .map((letter) => TextKey(
                text: letter,
                onTextInput: _textInputHandler,
                color: keyColors[letter] ?? Colors.grey))
            .toList(),
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
          children: [
        'ش',
        'س',
        'ي',
        'ب',
        'ل',
        'ا',
        'ت',
        'ن',
        'م',
        'ك',
        'ذ',
        'د',
      ]
              .map((letter) => TextKey(
                  text: letter,
                  onTextInput: _textInputHandler,
                  color: keyColors[letter] ?? Colors.grey))
              .toList()),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          SubmitKey(
            flex: 2,
            onSubmit: _submitHandler,
          ),
          ...[
            'ئ',
            'ء',
            'ؤ',
            'ر',
            'ى',
            'ة',
            'و',
            'ز',
            'ط',
            'ظ',
          ]
              .map((letter) => TextKey(
                  text: letter,
                  onTextInput: _textInputHandler,
                  color: keyColors[letter] ?? Colors.grey))
              .toList(),
          BackspaceKey(
            flex: 2,
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    super.key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
    required this.color,
  });

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: color,
          child: InkWell(
            onTap: () {
              onTextInput.call(text);
            },
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    super.key,
    required this.onBackspace,
    this.flex = 1,
  });

  final VoidCallback onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade600,
          child: InkWell(
            onTap: () {
              onBackspace.call();
            },
            child: const Center(
              child: Icon(Icons.backspace),
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitKey extends StatelessWidget {
  const SubmitKey({
    super.key,
    this.flex = 1,
    required this.onSubmit,
  });

  final int flex;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade600,
          child: InkWell(
            onTap: () {
              onSubmit.call();
            },
            child: const Center(
              child: Text(
                "إدخال",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
