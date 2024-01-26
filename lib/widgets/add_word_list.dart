import 'package:flutter/cupertino.dart';

class AddWordListWidget extends StatefulWidget {
  const AddWordListWidget({required this.listToDisplay, super.key});

  final List<String> listToDisplay;

  @override
  State<StatefulWidget> createState() {
    return _AddWordListWidgetState();
  }
}

class _AddWordListWidgetState extends State<AddWordListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.listToDisplay.map((e) => Text(e)).toList(),
    );
  }
}
