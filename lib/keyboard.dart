import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onSubmit,
  });

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

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
          TextKey(
            text: 'ض',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ص',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ث',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ق',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ف',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'غ',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ع',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ه',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'خ',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ح',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ج',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'إ',
            onTextInput: _textInputHandler,
            
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: 'ش',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'س',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ي',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ب',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ل',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ا',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ت',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ن',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'م',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ك',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ذ',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'د',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
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
          TextKey(
            text: 'ئ',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ء',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ؤ',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ر',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ى',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ة',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'و',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ز',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ط',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: 'ظ',
            onTextInput: _textInputHandler,
          ),
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
  });

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey,
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
