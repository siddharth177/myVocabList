import 'package:flutter/cupertino.dart';

class WordExampleDisplayWidget extends StatefulWidget {
  const WordExampleDisplayWidget({required this.examples, super.key});

  final List<String> examples;

  @override
  State<StatefulWidget> createState() {
    return _WordExampleDisplayWidgetState();
  }
}

class _WordExampleDisplayWidgetState extends State<WordExampleDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> m = widget.examples.map((e) => Text(e)).toList();

    return Container(
      child: Column(
        children: m,
      ),
    );

    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.examples.length,
          itemBuilder: (context, index) {
            return Text(widget.examples[index]);
          }),
    );
  }
}
