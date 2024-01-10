import 'package:flutter/cupertino.dart';

class WordUsageDisplayWidget extends StatefulWidget {
  const WordUsageDisplayWidget({required this.usages, super.key});

  final List<String> usages;

  @override
  State<StatefulWidget> createState() {
    return _WordUsageDisplayWidgetState();
  }
}

class _WordUsageDisplayWidgetState extends State<WordUsageDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> m = widget.usages.map((e) => Text(e)).toList();

    return Container(
      child: Column(
        children: m,
      ),
    );

    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.usages.length,
          itemBuilder: (context, index) {
            return Text(widget.usages[index]);
          }),
    );
  }
}
