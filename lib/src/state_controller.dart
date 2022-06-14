import 'package:flutter/material.dart';

class KIStateController {
  KIStateController(String stateName) : _state = ValueNotifier(stateName);

  final ValueNotifier<String> _state;

  ValueNotifier<String> get state => _state;

  String get stateName => _state.value;

  void updateState(String stateName) => _state.value = stateName;

  late AnimationStatus _animationStatus = AnimationStatus.completed;

  AnimationStatus get animationStatus => _animationStatus;

  @protected
  void updateAnimationStatus(AnimationStatus status) {
    _animationStatus = status;
  }
}
