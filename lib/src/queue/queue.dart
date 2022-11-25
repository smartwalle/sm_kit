import 'dart:collection';
import 'package:collection/collection.dart' show HeapPriorityQueue;

abstract class KIQueue<E> {
  int get length;

  bool get isEmpty;

  bool get isNotEmpty;

  E get first;

  E removeFirst();

  void add(E value);
}

class KIListQueue<E> extends ListQueue<E> implements KIQueue<E> {}

class KIPriorityQueue<E> extends HeapPriorityQueue<E> implements KIQueue<E> {
  KIPriorityQueue([int Function(E, E)? comparison]) : super(comparison);
}
