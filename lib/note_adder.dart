import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class noteAdder extends StatefulWidget {
  const noteAdder({Key? key}) : super(key: key);

  @override
  _noteAdderState createState() => _noteAdderState();
}

class _noteAdderState extends State<noteAdder> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  createNote(Map<String, String> noteData) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyNotes").doc(noteData["title"]);

    documentReference
        .set(noteData)
        .whenComplete(() => print("Added successfully"));
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () {
          AlertDialog noteAdder = AlertDialog(
            title: const Text("Add Note"),
            content: Flexible(
              // width: 350,
              // height: 200,
              fit: FlexFit.tight,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      // minLines: 1,
                      // maxLi: 2,
                      controller: titleController,
                      decoration: const InputDecoration(hintText: "Title"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a title";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: contentController,
                      decoration: const InputDecoration(hintText: "Content"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Note cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            setState(() {
                              Map<String, String> currentNoteData = {
                                "title": titleController.text,
                                "content": contentController.text
                              };
                              createNote(currentNoteData);
                              // notes.add(currentNoteData);

                              titleController.text = "";
                              contentController.text = "";
                            });
                          }
                        },
                        child: const Text("Submit"))
                  ],
                ),
              ),
            ),
          );

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return noteAdder;
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
