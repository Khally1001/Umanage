import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  List<String> allTasks = [];

  Future<void> loadAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      allTasks = prefs.getStringList('completedTasks') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Tasks',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: allTasks.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : ListView.builder(
              itemCount: allTasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            child: Text("${index + 1}"),
                          ),
                          title: Text(allTasks[index]),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          setState(() {
                            allTasks.removeAt(index);
                          });
                          await prefs.setStringList('completedTasks', allTasks);
                        },
                        icon: const Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
