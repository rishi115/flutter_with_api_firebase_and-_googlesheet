import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/main.dart';

class DetailPage extends StatefulWidget {
  final ListItem item;

  DetailPage({required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> _studentNames = [];
  Map<String, bool> _attendanceStatus = {};
  late final List<String> _scopes;
  late final ServiceAccountCredentials _credentials;

  @override
  void initState() {
    super.initState();
    _fetchStudentNames();

    // Initialize Google Sheets API credentials and scopes
    _scopes = [SheetsApi.spreadsheetsScope];
    _credentials = ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "gsheet-384920",
  "private_key_id": "f289d37a745a002d64b6f4f3e3ac4e9d19a02a02",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDTv9OwnLZYt5Iz\nY9T7IkNSbazB/JoUe+IvH0aI3aX7TZToD0MOdaejS81ScbA81KJHzjNK8oPREr9g\nzPnNjmQGILkTizS/HrH63vNf7Jl+j/3yriuKAcaMxCMhvfxx4uJkpQwx4VcPbgdy\nlPZp9xJs7j2mM4SFaSu2d+ilfyq4CR9letzM6zLvyrXGnYthTt6bt6ZuKnc+nQoE\nIXU0rZ5Mlou8xfWYwFDtLIuq/XSYbNBObtu4/RAJ3yoTQq5m6QCzbUypu2yH3ofF\nBTtuxLv8xaUm3D+2Q9Ziy5H//VHQ1PZ8KLzzHSEtmaCQY7kJy224V21eAdMrgop4\npJehUQ2TAgMBAAECggEAHDVJQ5VU21O1F8B8Xmotkr0Gjx8R/ZmVQ5bEhDYWxvgK\nVrG1yqbUyrWt6AY6Jphi9/LZtWnCMqdvNDuKKZ6G56QTU62vPKifqB5sSIKR3iDb\ngSk/ppZe92Cnl3aiOx+w7hxol/p/aRBM0LBUdUBTRYylTM8/H7CngJrPtMBQlgxu\nyDY0oi4SbhLtcdQSkvoOUKF5UmcvjcS1MWaaN/lIHcwag/dcFBcJmbZJtx3RlJu1\naOuWfKiDmof4Vqunj0esqegu5veZ+NnWZSoXT9uXu+w0rECvnc+b5iD3yoaKVHiQ\nF/+kpu4Lg+6UmtBB6NwQFK6Awk1cXBSm+qxSUar7LQKBgQD+uqX6AvRLZi43EeF5\nRbksiOUM4GDRZjV+NiGUItCTl28BbXbWJ1yDFifZwANd7qga156hnaqrIBG+g1GQ\nlcWDazXNld9k+tE74WHPE4S6aH8k/2g3sg9gjsNboPCoy3KjczjSba3+fBb6ngxd\nGFfNJSqLkdZQGyymnOGs+3/S1QKBgQDUzkhoCJ7gBtZRf3SG1tHXlg/IV2xu0rGO\npVIRDcXf2bpRyeU5LMWWx5VUjtC5L2ltajvuY4sJncvesWJlrHMHPfVZt2BR10XS\nr0TQoE6qKxyvFgKwZqJIEEOuRWlw2n0JBey3LOdb/X8sJOWy2gJXb/xiZaPvR7mv\n+jf44lSCxwKBgBFfva5dwTfbUk+jQpO487Zb5/OG4lOl+wQOwR+PeFZ4v7ODOdXF\nfYPbYQBzHker3X9nMYSoclmVqGAsKMYJ0RzzlQnerQwAJ4FEEB3FoQnt0q49VWhn\nFrFpS13WjlOU/M61Lyz7GiD/abnSSdmXrXVqkYpPeiSgld0PWj0oMkG5AoGAbF9M\n8mYJeq8gr8pHrm9x1+dczDrxRpLXx3wbigHIllIMF6DIslBBo6KqQrCkTNp/RzBF\nqwZYhSIt84/EO2ESB0sfSnwfei42KbAGTHSG+xQPfH6qCemKlUZrITHKG6W47UJu\nJW6ht/AltnZn36g0bxDhp755ON7/CkZUANRKE3sCgYEAyTZg5wK1lzqwj5g19zHt\nDddwbnm69KEv3SE5hLE03qijzU4bvG9TSvvaCpRz0s3gX9zTakehUf0BSuEm5vav\nP8u+IBvhGR3YkvCnIB5Kd3V5MztXfwRPzIUw/fgugHVNjHecVgMujtNIZuWxHnB3\nf7cJqxEiat9d4cvAVhe+FwY=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheet@gsheet-384920.iam.gserviceaccount.com",
  "client_id": "100810567459987202357",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet%40gsheet-384920.iam.gserviceaccount.com"


    });
  }

  void _fetchStudentNames() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .where('title', isEqualTo: widget.item.title)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docs = snapshot.docs;
      List<String> names = [];
      for (var doc in docs) {
        names.add(doc['name']);
        _attendanceStatus[doc['name']] = false; // Initialize attendance status
      }
      setState(() {
        _studentNames = names;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: ListView.builder(
        itemCount: _studentNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2,
            color: _attendanceStatus[_studentNames[index]] == true
                ? Colors.green
                : Colors.white,
            child: Container(
              height: 80,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  _studentNames[index],
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(
                            context, _studentNames[index]);
                      },
                      child: Text(
                        'Paid',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String studentName) async {
    final sheetsApi = SheetsApi(
        await clientViaServiceAccount(_credentials, _scopes));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Attendance'),
          content: Text('Did $studentName pay the class fees?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _attendanceStatus[studentName] = true;
                });
                Navigator.pop(context);

                // Add attendance data to Google Sheet
                final spreadsheetId = '1UR4fyNtd-vvvRQPDDBIJzMYquNp7H4NcU11T6qwh1gc';
                final range = 'Users!A1:B1';

                final valueRange = ValueRange.fromJson({
                  'range': range,
                  'majorDimension': 'ROWS',
                  'values': [
                    [(studentName), 'Paid'],
                  ],
                });

                try {
                  final response = await sheetsApi.spreadsheets.values.append(
                    valueRange,
                    spreadsheetId,
                    range,
                    valueInputOption: 'USER_ENTERED',
                  );

                  print('Attendance data added to Google Sheet: $response');
                } catch (e) {
                  print('Failed to add attendance data to Google Sheet: $e');
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
