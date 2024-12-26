import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, dynamic content){
  ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
    content: Text(content.toString()),
  ));
}