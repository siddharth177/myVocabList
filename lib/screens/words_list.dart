import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final _formKey = GlobalKey<FormState>();
  String _word = '';
  String _phonatic = '';
  String _root = '';
  WordClass _wordClass = WordClass.none;
  List<String> _meanings = [];
  List<String> _usages = [];
  List<String> _examples = [];

  Future<void> _onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _vocabList.add(WordMeaning(
            word: _word,
            meanings: _meanings,
            usages: _usages,
            examples: _examples,
            wordClass: _wordClass,
            root: _root,
            phonatic: _phonatic));

        _filteredVocabList = _vocabList;
      });

      var db = FirebaseFirestore.instance;

      var toadd = WordMeaning(
          word: _word,
          meanings: _meanings,
          usages: _usages,
          examples: _examples,
          wordClass: _wordClass,
          root: _root,
          phonatic: _phonatic);

      var uid = FirebaseAuth.instance.currentUser?.uid;
      final res = await db
          .collection('users')
          .doc(uid)
          .collection('vocabList')
          .withConverter(
              fromFirestore: WordMeaning.fromFirestore,
              toFirestore: (WordMeaning toadd, options) => toadd.toFirestore())
          .doc(_word)
          .set(toadd);

      Navigator.of(context).pop();
    }
  }

  TextEditingController _controller = TextEditingController();

  // @override
  // void initState() async {
  //   super.initState();
  //   loadInitialData();
  // }
  //
  // Future loadInitialData() async {
  //   FutureBuilder _firestoreData = FutureBuilder(future: FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('vocabList').get(), builder: (BuildContext context, DocumentSnapshot snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     }
  //
  //     if (!snapshot.hasData || vocabSnapshots.data!.docs.isEmpty) {
  //       return Center(
  //         child: Text('No data'),
  //       );
  //     }
  //
  //     if (snapshot.hasError) {
  //       return Center(
  //         child: Text('Error'),
  //       );
  //     }
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final TextEditingController colorController = TextEditingController();
    void _openAddExpenseOverlay() {
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
        // useSafeArea: true,
        isScrollControlled: true,
      );
    }

    // if (_filteredVocabList.isEmpty) {
    //   _filteredVocabList = _vocabList;
    // }

    final _searchBarController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SearchBar(
                // controller: _searchBarController,
                leading: Icon(Icons.search),
                onChanged: (query) {
                  _searchBarController.text = query;
                  setState(() {
                    _query = query;
                    // _filteredVocabList = _vocabList
                    //     .where((element) => element.word
                    //         .toLowerCase()
                    //         .contains(_query.toLowerCase()))
                    //     .toList();
                  });
                },
                trailing: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _searchBarController.clear();
                          _query = '';
                          // _filteredVocabList = _vocabList;
                          // _list = sampleData;
                        });
                      },
                      icon: Icon(Icons.clear)),
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.download),
              color: Colors.blue,
            ),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout))
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!vocabSnapshots.hasData || vocabSnapshots.data!.docs.isEmpty) {
            return Center(
              child: Text('No data'),
            );
          }

          if (vocabSnapshots.hasError) {
            return Center(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _openAddExpenseOverlay,
        tooltip: "Add A Word",
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 40,
        // shadowColor: Colors.transparent,
        elevation: 0,
        // color: Colors.purple,
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))) //
            ),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}
