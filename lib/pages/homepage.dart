import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/pages/all_tasks_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isVisible = false;
  bool isAdd = true;
  List<String> completedTasks = [];
  final TextEditingController taskInputController = TextEditingController();

  Future<void> saveTask(String task) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('completedTasks') ?? [];
    tasks.add(task);
    await prefs.setStringList('completedTasks', tasks);
    setState(() {
      completedTasks = tasks;
    });
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedTasks = prefs.getStringList('completedTasks') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    taskInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final limitedTasks = completedTasks.length > 3
        ? completedTasks.take(3).toList()
        : completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Umanage',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 25,
            color: Colors.deepPurple,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (completedTasks.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...limitedTasks.map((task) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.remove,
                            color: Colors.deepPurple,
                          ),
                          title: Text(task),
                        ),
                      );
                    }).toList(),
                    if (completedTasks.length > 3)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllTasksPage(),
                            ),
                          ).then((_) {
                            loadTasks();
                          });
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            if (isVisible)
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 177, 145, 232),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 184, 169, 187),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Are you sure this is your new task?',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  if (taskInputController.text.isNotEmpty) {
                                    await saveTask(
                                      taskInputController.text.trim(),
                                    );
                                    setState(() {
                                      isVisible = false;
                                      isAdd = true;
                                      taskInputController.clear();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isVisible = false;
                                    isAdd = true;
                                    taskInputController.clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: taskInputController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'Enter task...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(isAdd ? Icons.add : Icons.close),
        onPressed: () {
          setState(() {
            isVisible = !isVisible;
            isAdd = !isAdd;
          });
        },
      ),
    );
  }
}
