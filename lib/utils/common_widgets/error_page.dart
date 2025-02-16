import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    required this.errorText,
    super.key,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorText),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    required this.errorText,
    super.key,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorText(errorText: errorText),
    );
  }
}
