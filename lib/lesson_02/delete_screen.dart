import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/data.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final Box<Data> _deletedTasks = Hive.box('deletedTasks');
  final Box<Data> _taskBox = Hive.box('tasks');

  void recovery(int index) {
    setState(() {
      _taskBox.add(_deletedTasks.getAt(index)!);
      _deletedTasks.deleteAt(index);
    });
  }

  void delete(int index) {
    setState(() {
      _deletedTasks.deleteAt(index);
    });
  }

  void clearAll() {
    setState(() {
      _deletedTasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Screen'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                clearAll();
              });
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _deletedTasks.listenable(),
        builder: (context, Box<Data> value, Widget? child) {
          if (value.isEmpty) {
            return const Center(
              child: Text("No deleted tasks yet"),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (context, index) {
              final task = value.getAt(index);
              return ListTile(
                title: Text(task!.title),
                subtitle: Text(task.notes),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        recovery(index);
                      },
                      icon: const Icon(Icons.restore),
                    ),
                    IconButton(
                      onPressed: () {
                        delete(index);
                      },
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
