import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Get a reference to the "attendance" collection
        stream: FirebaseFirestore.instance.collection('attendance').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Map the documents to a list of widgets
            List<Widget> attendanceList = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              // Check if the name and status properties are not null, and provide default values if they are
              String name = data['name'] ?? '';
              String status = data['status'] ?? '';

              // Create a CardView with the document data
              return Card(
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(status),
                ),
              );
            }).toList();

            // Display the list of CardViews in a ListView
            return ListView(
              children: attendanceList,
            );
          } else {
            // Display a progress indicator while data is being loaded
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
