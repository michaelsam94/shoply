import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';

/// Content for a main tab. The [MainNavigationShell] provides the bottom bar.
class TabPageScaffold extends StatelessWidget {
  const TabPageScaffold({
    required this.title,
    required this.body,
    super.key,
    this.actions,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kWebMaxWidth),
          child: body,
        ),
      ),
    );
  }
}
