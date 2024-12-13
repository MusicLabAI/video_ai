import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.canPop = true});

  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => canPop,
        child: const Center(child: CircularProgressIndicator()));
  }
}
