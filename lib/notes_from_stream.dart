import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class notesFromStream extends StatefulWidget {
  const notesFromStream({Key? key}) : super(key: key);

  @override
  _notesFromStreamState createState() => _notesFromStreamState();
}

class _notesFromStreamState extends State<notesFromStream> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('MyNotes').snapshots();
  CollectionReference notes = FirebaseFirestore.instance.collection('MyNotes');

  Future<void> deleteNote(String noteTitle) {
    return notes.doc(noteTitle).delete().then((value) => print("Deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text(data["title"]),
                subtitle: Text(data["content"]),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 100,
                            width: 300,
                            child: Column(
                              children: [
                                Text("${data["title"]}"),
                                Expanded(
                                  child: SingleChildScrollView(
                                      child: Text("${data["content"]}")),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                trailing: TextButton(
                  child: const Icon(
                    Icons.check_sharp,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${data["title"]} Done"),
                      duration: const Duration(seconds: 1),
                    ));
                    setState(() {
                      deleteNote(data["title"]);
                    });
                  },
                ),
              ),
              elevation: 5,
            );
          }).toList(),
        );
      },
    );
  }
}
