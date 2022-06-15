abstract class KIStateDelegate<T> {
  T build(String nState);
}

class KIStateListDelegate<T> extends KIStateDelegate<T> {
  KIStateListDelegate(
    this.children,
  );

  final List<T> children;

  @override
  build(String nState) {
    if (nState.isEmpty) {
      return children.first;
    }
    return children.firstWhere((element) => element == nState);
  }
}

typedef KIStateBuilder<T> = T Function(String nState);

class KIStateBuilderDelegate<T> extends KIStateDelegate<T> {
  KIStateBuilderDelegate(
    this.stateBuilder,
  );

  KIStateBuilder<T> stateBuilder;

  @override
  T build(String nState) {
    return stateBuilder(nState);
  }
}
