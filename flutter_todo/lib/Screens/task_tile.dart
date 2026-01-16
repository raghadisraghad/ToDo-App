import 'package:flutter/material.dart';
import 'package:todospring/models/task.dart';
import 'package:todospring/models/tasks_data.dart';
import 'package:todospring/Screens/edit_task_screen.dart'; // Import the EditTaskScreen

class TaskTile extends StatelessWidget {
  final Task task;
  final TasksData tasksData;

  const TaskTile({
    Key? key,
    required this.task,
    required this.tasksData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: task.done
            ? Colors.green.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: task.done
                ? Colors.greenAccent.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            task.done ? Icons.check : Icons.circle_outlined,
            color: task.done ? Colors.greenAccent : Colors.grey,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: task.done ? TextDecoration.lineThrough : null,
            color: task.done ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: task.done
            ? Text(
          'Completed',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 12,
          ),
        )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                ).then((updatedTask) {
                  if (updatedTask != null) {
                    tasksData.updateTask(updatedTask);
                  }
                });
              },
            ),
            Switch.adaptive(
              value: task.done,
              onChanged: (value) {
                tasksData.updateTaskDone(task);
              },
              activeColor: Colors.greenAccent,
              activeTrackColor: Colors.greenAccent.withOpacity(0.4),
            ),
          ],
        ),
        onTap: () {
          tasksData.updateTaskDone(task);
        },
      ),
    );
  }
}