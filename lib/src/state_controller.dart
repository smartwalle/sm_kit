import 'package:flutter/material.dart';

class KIStateController extends ValueNotifier<String> {
  KIStateController(String state) : super(state);

  String get state => value;

  set state(String newState) {
    value = newState;
  }
}
