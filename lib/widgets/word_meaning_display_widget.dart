import 'package:flutter/cupertino.dart';

class WordMeaningDisplayWidget extends StatefulWidget {
  const WordMeaningDisplayWidget({required this.meanings, super.key});

  final List<String> meanings;

  @override
  State<StatefulWidget> createState() {
    return _WordMeaningDisplayWidgetState();
  }
}

class _WordMeaningDisplayWidgetState extends State<WordMeaningDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> m = widget.meanings.map((e) => Text(e)).toList();

    return Container(
      child: Column(
        children: m,
      ),
    );

    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.meanings.length,
          itemBuilder: (context, index) {
            return Text(widget.meanings[index]);
          }),
    );
  }
}
