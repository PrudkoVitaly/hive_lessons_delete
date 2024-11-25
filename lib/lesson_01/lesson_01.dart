import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _controller = TextEditingController();
  final Box notes = Hive.box("notes");
  final Box deletedNotes = Hive.box("deletedNotes");

  void addNote() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        notes.add(_controller.text);
        _controller.clear();
      }
    });
  }

  void deleteNote(int index) {
    setState(() {
      deletedNotes.add(notes.getAt(index));
      notes.deleteAt(index);
    });
  }
  void delete(int index) {
    setState(() {
      deletedNotes.deleteAt(index);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addNote();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Text("Задачи"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: notes.listenable(),
                    builder: (context, box, _) {
                      if (box.isEmpty) {
                        return const Center(
                          child: Text("No Notes"),
                        );
                      }
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final note = box.getAt(index);
                            return ListTile(
                              title: Text(note),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteNote(index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Text("Удаленные задачи"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: deletedNotes.listenable(),
                    builder: (context, box, _) {
                      if (box.isEmpty) {
                        return const Center(
                          child: Text("No Notes"),
                        );
                      }
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final note = box.getAt(index);
                            return ListTile(
                              title: Text(note),
                              trailing: IconButton(
                                onPressed: () {
                                  delete(index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
