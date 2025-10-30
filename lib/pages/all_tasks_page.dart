import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  Future<void> scheduleReminder(int hoursLater) async {
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(hours: hoursLater));

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Reminders',
      channelDescription: 'Scheduled reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'It’s been $hoursLater seconds! Don’t forget your task.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for $hoursLater hours from now!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (kDebugMode) {
      debugPrint("Notification scheduled for $scheduledDate");
    }
  }

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
                      IconButton(
                        onPressed: () {
                          scheduleReminder(5);
                        },
                        icon: const Icon(Icons.alarm_add),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
