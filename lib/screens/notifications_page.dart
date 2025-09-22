import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notification data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Subsidy Alert',
        'description': 'New agricultural subsidy scheme available for coconut farmers',
        'timestamp': '2 hours ago',
        'isRead': false,
      },
      {
        'title': 'Advisory: Leaf Spot Disease',
        'description': 'Important advisory about leaf spot disease prevention in paddy fields',
        'timestamp': '1 day ago',
        'isRead': true,
      },
      {
        'title': 'System Update',
        'description': 'New discussion feature added to the app',
        'timestamp': '3 days ago',
        'isRead': true,
      },
      {
        'title': 'Weather Alert',
        'description': 'Heavy rainfall expected in your area. Take necessary precautions.',
        'timestamp': '5 days ago',
        'isRead': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A7C59),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: notification['isRead'] 
                    ? Colors.grey[300] 
                    : const Color(0xFF4A7C59),
                child: Icon(
                  Icons.notifications,
                  color: notification['isRead'] 
                      ? Colors.grey[600] 
                      : Colors.white,
                ),
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: notification['isRead'] 
                      ? FontWeight.normal 
                      : FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification['timestamp'],
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle notification tap
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped on: ${notification['title']}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
