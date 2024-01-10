import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_dictionary/models/word_meaning.dart';
import 'package:personal_dictionary/widgets/word_examples_display_widget.dart';
import 'package:personal_dictionary/widgets/word_meaning_display_widget.dart';
import 'package:personal_dictionary/widgets/word_usage_display_widget.dart';

import 'add_word_widget.dart';

class WordDisplayWidget extends StatefulWidget {
  const WordDisplayWidget({required this.wordMeaning, super.key});

  final WordMeaning wordMeaning;

  @override
  State<StatefulWidget> createState() {
    return _WordDisplayWidgetState();
  }
}

class _WordDisplayWidgetState extends State<WordDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(12),
      color: Colors.red,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.green,
        highlightColor: Colors.yellow,
        onTap: () {
          print('tapped');
        },
        child: Slidable(
          key: ValueKey(widget.wordMeaning.word),
          startActionPane: ActionPane(
            motion: DrawerMotion(),
            // dismissible: DismissiblePane(
            //   onDismissed: () {
            //     // AddWordWidget(
            //     //   word: widget.wordMeaning.word,
            //     //   root: widget.wordMeaning.root,
            //     //   phonatic: widget.wordMeaning.phonatic,
            //     //   wordClass: widget.wordMeaning.wordClass,
            //     //   examples: widget.wordMeaning.examples,
            //     //   usages: widget.wordMeaning.usages,
            //     //   meanings: widget.wordMeaning.meanings,
            //     // );
            //   },
            // ),
            children: [
              SlidableAction(
                onPressed: (context) {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return AddWordWidget(
                        word: widget.wordMeaning.word,
                        root: widget.wordMeaning.root,
                        phonatic: widget.wordMeaning.phonatic,
                        wordClass: widget.wordMeaning.wordClass,
                        examples: widget.wordMeaning.examples,
                        usages: widget.wordMeaning.usages,
                        meanings: widget.wordMeaning.meanings,
                      );
                    },
                    isScrollControlled: true,
                  );
                },
                backgroundColor: Colors.blue,
                icon: Icons.edit,
                label: 'Edit',
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('vocabList')
                    .doc(widget.wordMeaning.word)
                    .delete();
              },
            ),
            children: [
              SlidableAction(
                onPressed: (context) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('vocabList')
                      .doc(widget.wordMeaning.word)
                      .delete();
                },
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: 'Delete',
              )
            ],
          ),
          child: ListTile(
            title: Text(widget.wordMeaning.word),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.wordMeaning.wordClass.name),
                    Text(widget.wordMeaning.phonatic),
                  ],
                ),
                WordMeaningDisplayWidget(
                  meanings: widget.wordMeaning.meanings,
                ),
                WordUsageDisplayWidget(
                  usages: widget.wordMeaning.usages,
                ),
                WordExampleDisplayWidget(examples: widget.wordMeaning.examples)
              ],
            ),
          ),
        ),
      ),
    );
  }
}