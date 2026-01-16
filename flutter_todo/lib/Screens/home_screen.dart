import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todospring/Services/database_services.dart';
import 'package:todospring/models/task.dart';
import 'package:todospring/models/tasks_data.dart';
import 'package:todospring/screens/login_screen.dart'; // Import your LoginScreen
import 'package:todospring/screens/register_screen.dart'; // Import your RegisterScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todospring/Screens/edit_task_screen.dart';

import '../task_tile.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task>? tasks;
  bool isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isFirst == true) {
      checkLoginStatus();
    }
  }

  // Check if user is logged in
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('token') != null; // Check if token exists
    });
    if (isLoggedIn) {
      getTasks(); // Fetch tasks only if logged in
    }
  }

  // Fetch tasks from the database
  void getTasks() async {
    tasks = await DatabaseServices.getTasks();
    Provider.of<TasksData>(context, listen: false).tasks = tasks!;
    setState(() {});
  }

  // Logout the user
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user'); // Remove the token from local storage
    setState(() {
      isLoggedIn = false; // Update login status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isLoggedIn
              ? 'Todo List (${Provider.of<TasksData>(context).tasks.length})'
              : 'Todo List',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout_outlined, color: Colors.blueAccent),
              onPressed: logout,
            ),
        ],
      ),
      body: isLoggedIn
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<TasksData>(builder: (context, tasksData, child) {
          return Column(
            children: [
              // Only show the buttons if there are tasks
              if (tasksData.tasks.isNotEmpty) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete All Tasks'),
                                    ],
                                  ),
                                  content: Text(
                                      'Are you sure you want to delete all tasks?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: Colors.grey)),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: Text('Delete',
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmDelete == true) {
                              await DatabaseServices.deleteAllTasks();
                              getTasks();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline, size: 18),
                              SizedBox(width: 8),
                              Text('Delete All'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? confirmMarkDone = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: Colors.green),
                                      SizedBox(width: 8),
                                      Text('Mark All Done'),
                                    ],
                                  ),
                                  content: Text(
                                      'Mark all tasks as completed?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: Colors.grey)),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      child: Text('Mark All',
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmMarkDone == true) {
                              await DatabaseServices.markAllTasksAsDone();
                              getTasks();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.1),
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 18),
                              SizedBox(width: 8),
                              Text('Mark All Done'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: tasksData.tasks.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No tasks yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add your first task',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: tasksData.tasks.length,
                  itemBuilder: (context, index) {
                    Task task = tasksData.tasks[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: task.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.done
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit_outlined,
                                      color: Colors.blueAccent),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditTaskScreen(
                                                task: task),
                                      ),
                                    ).then((updatedTask) {
                                      if (updatedTask != null) {
                                        tasksData
                                            .updateTask(updatedTask);
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog<bool>(
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(Icons.delete_outline,
                                                  color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete Task'),
                                            ],
                                          ),
                                          content: Text(
                                              'Are you sure you want to delete this task?'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .grey)),
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                                tasksData.deleteTask(
                                                    task);
                                              },
                                              style: ElevatedButton
                                                  .styleFrom(
                                                  backgroundColor:
                                                  Colors
                                                      .red),
                                              child: Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                Checkbox(
                                  value: task.done,
                                  onChanged: (value) {
                                    tasksData.updateTaskDone(task);
                                  },
                                  activeColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_outlined,
                size: 60,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Welcome to Todo App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sign in to manage your tasks',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Login'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.blueAccent),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return const AddTaskScreen();
            },
          );
        },
      )
          : null,
    );
  }
}