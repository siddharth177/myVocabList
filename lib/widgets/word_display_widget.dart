import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_dictionary/models/word_meaning.dart';
import 'package:personal_dictionary/widgets/display_vocab_list_element.dart';

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
  void _editWordField() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: Theme.of(context).cardTheme.color,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white,
        // highlightColor: Colors.yellow,
        onTap: () {
          _editWordField();
        },
        child: Slidable(
          key: ValueKey(widget.wordMeaning.word),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _editWordField();
                },
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icons.edit,
                label: 'Edit',
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
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
                backgroundColor: Theme.of(context).disabledColor,
                icon: Icons.delete,
                label: 'Delete',
              )
            ],
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.wordMeaning.word,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(widget.wordMeaning.root)
              ],
            ),
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
                DisplayVocabListElement(
                  listToDisplay: widget.wordMeaning.meanings,
                ),
                DisplayVocabListElement(
                  listToDisplay: widget.wordMeaning.usages,
                ),
                DisplayVocabListElement(
                    listToDisplay: widget.wordMeaning.examples)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
