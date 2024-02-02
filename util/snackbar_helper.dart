// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.red),
    ),
    backgroundColor: Colors.white,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
