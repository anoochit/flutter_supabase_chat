import 'package:flutter/material.dart';

class CenterLoading extends StatelessWidget {
  const CenterLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Loading..."),
          ),
        ],
      ),
    );
  }
}
