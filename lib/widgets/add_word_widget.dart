import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/word_meaning.dart';

class AddWordWidget extends StatefulWidget {
  AddWordWidget(
      {required this.word,
      required this.root,
      required this.phonatic,
      required this.wordClass,
      required this.examples,
      required this.usages,
      required this.meanings,
      super.key});

  String word = '';
  String phonatic = '';
  String root = '';
  WordClass wordClass = WordClass.none;
  List<String> meanings = [];
  List<String> usages = [];
  List<String> examples = [];

  @override
  State<StatefulWidget> createState() {
    return _AddWordWidgetState();
  }
}

class _AddWordWidgetState extends State<AddWordWidget> {
  final _formKey = GlobalKey<FormState>();
  String _word = '';
  String _phonatic = '';
  String _root = '';
  WordClass _wordClass = WordClass.none;
  List<String> _meanings = [];
  List<String> _usages = [];
  List<String> _examples = [];

  @override
  void initState() {
    super.initState();
    _word = widget.word;
    _phonatic = widget.phonatic;
    _root = widget.root;
    _wordClass = widget.wordClass;
    _meanings = widget.meanings;
    _usages = widget.usages;
    _examples = widget.examples;

    print('meanings $_meanings');
  }

  TextEditingController _controller = TextEditingController();

  Future<void> _onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQueryData.fromView(WidgetsBinding.instance.window)
              .padding
              .top),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Your Word"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            // .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                TextFormField(
                  initialValue: _word.isNotEmpty ? _word : '',
                  decoration: InputDecoration(
                    label: Text("Word"),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length <= 1) {
                      return 'Word cannot be empty';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _word = value!;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DropdownMenu<WordClass>(
                      initialSelection: _wordClass != WordClass.none
                          ? _wordClass
                          : WordClass.none,
                      // controller: colorController,
                      requestFocusOnTap: true,
                      label: Text('Word Class'),
                      dropdownMenuEntries: WordClass.values
                          .map<DropdownMenuEntry<WordClass>>((e) =>
                              DropdownMenuEntry<WordClass>(
                                  value: e, label: e.name))
                          .toList(),
                      onSelected: (value) {
                        _wordClass = value!;
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: _phonatic,
                        decoration: InputDecoration(
                          label: Text('Phonatic'),
                        ),
                        onSaved: (value) {
                          if (value == null || value.trim().length <= 1) {
                            return;
                          } else {
                            _phonatic = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      // initialValue: ,
                      controller: _controller,
                      decoration: InputDecoration(
                        label: Text('Meanings'),
                      ),
                      onFieldSubmitted: (value) {
                        if (_meanings.isEmpty && widget.meanings.isNotEmpty) {
                          _meanings = widget.meanings;
                        }
                        _meanings.add(_controller.text);
                        _controller.clear();
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _meanings.map((e) => Text(e)).toList(),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: _onFormSubmit,
                  child: const Text('Add Item'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
