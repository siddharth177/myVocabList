import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/utils/firebase.dart';
import 'package:personal_dictionary/widgets/loading.dart';
import 'package:personal_dictionary/widgets/word_display_widget.dart';

import '../models/word_meaning.dart';
import '../widgets/add_word_widget.dart';

class WordsListScreen extends StatefulWidget {
  const WordsListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordsListScreenState();
  }
}

class _WordsListScreenState extends State<WordsListScreen> {
  List<WordMeaning> _vocabList = [];
  List<WordMeaning> _filteredVocabList = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _query = '';

  @override
  Widget build(BuildContext context) {
    void openAddExpenseOverlay() {
      showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return AddWordWidget(
            word: '',
            root: '',
            phonatic: '',
            wordClass: WordClass.none,
            examples: [],
            usages: [],
            meanings: [],
          );
        },
        isScrollControlled: true,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SearchBar(
                leading: const Icon(Icons.search),
                onChanged: (query) {
                  setState(() {
                    _query = query;
                  });
                },
                trailing: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _query = '';
                        });
                      },
                      icon: const Icon(Icons.clear)),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
                onPressed: () {
                  firebaseAuthInstance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('vocabList')
            .snapshots(),
        builder: (context, vocabSnapshots) {
          if (vocabSnapshots.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (!vocabSnapshots.hasData || vocabSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          }

          if (vocabSnapshots.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }

          _vocabList.clear();
          for (var doc in vocabSnapshots.data!.docs) {
            _vocabList.add(WordMeaning.fromFirestore(doc, null));
          }

          _filteredVocabList = _vocabList
              .where((element) => element.word.contains(_query))
              .toList();

          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _filteredVocabList.length,
              itemBuilder: (context, index) {
                return WordDisplayWidget(
                    wordMeaning: _filteredVocabList[index]);
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 2,
          onPressed: openAddExpenseOverlay,
          tooltip: "Add A Word",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
