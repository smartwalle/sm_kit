import 'package:flutter/widgets.dart';

class KIKeepAlive extends StatefulWidget {
  const KIKeepAlive({
    Key? key,
    this.keepAlive = true,
    required this.child,
  }) : super(key: key);

  final bool keepAlive;
  final Widget child;

  @override
  State<KIKeepAlive> createState() => _KIKeepAliveState();
}

class _KIKeepAliveState extends State<KIKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KIKeepAlive oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
