import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'data/data.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final Box<Data> _taskBox = Hive.box('tasks');

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void save() {
    final title = titleController.text.trim();
    final notes = notesController.text.trim();
    if (key.currentState!.validate()) {
      setState(() {
        final data = Data(title: title, notes: notes);
        _taskBox.add(data);
        Navigator.pop(context);
        titleController.clear();
        notesController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title can't be empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: notesController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Notes can't be empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Notes",
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    save();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
