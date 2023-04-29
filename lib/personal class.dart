import 'package:cloud_firestore/cloud_firestore.dart';

void fetchAttendanceData() async {
  // Get a reference to the "attendance" collection
  CollectionReference attendanceRef = FirebaseFirestore.instance.collection('attendance');

  // Query for all documents in the collection
  QuerySnapshot querySnapshot = await attendanceRef.get();

  // Iterate over all documents and print their data to the console
  querySnapshot.docs.forEach((doc) {
    print(doc.data());
  });
}
