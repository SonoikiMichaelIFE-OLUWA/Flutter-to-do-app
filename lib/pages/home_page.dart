import 'package:flutter/material.dart';
import '../modules/date_and_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TodoItem> todos = [];
  final TextEditingController controller = TextEditingController();

  void addTodo() {
    if (controller.text.isNotEmpty) {
      setState(() {
        todos.add(TodoItem(title: controller.text));
        controller.clear();
      });
    }
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void toggleDone(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });
  }

  void pickDeadline(int index) async {
    final selectedDateTime =
    await DateTimeModule.pickDateTime(context);

    if (selectedDateTime != null) {
      setState(() {
        todos[index].deadline = selectedDateTime;
      });
    }
  }

  void removeDeadline(int index) {
    setState(() {
      todos[index].deadline = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My To-Do List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) => toggleDone(index),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: todo.deadline != null
                        ? Text(
                      "Deadline: ${todo.deadline}",
                      style: const TextStyle(color: Colors.red),
                    )
                        : const Text("No deadline set"),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'set',
                          child: Text("Set / Edit Deadline"),
                        ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text("Remove Deadline"),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("Delete Task"),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'set') {
                          pickDeadline(index);
                        } else if (value == 'remove') {
                          removeDeadline(index);
                        } else if (value == 'delete') {
                          deleteTodo(index);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isDone;
  DateTime? deadline;

  TodoItem({
    required this.title,
    this.isDone = false,
    this.deadline,
  });
}