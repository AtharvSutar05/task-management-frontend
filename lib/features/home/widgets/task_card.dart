import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final String due_at;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.due_at
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
