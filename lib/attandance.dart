import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/main.dart';
import 'package:intl/intl.dart';

class Detailscreen extends StatefulWidget {
  final ListItem item;

  Detailscreen({required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<Detailscreen> {
  List<String> _studentNames = [];
  Map<String, bool> _attendanceStatus = {};
  late final List<String> _scopes;
  late final ServiceAccountCredentials _credentials;

  @override
  void initState() {
    super.initState();
    _fetchStudentNames();
    _scopes = [SheetsApi.spreadsheetsScope];
    _credentials = ServiceAccountCredentials.fromJson({

        "type": "service_account",
        "project_id": "gsheet-384920",
        "private_key_id": "605b448827c0f8320a7db9cdbf20f813fc8a2817",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDAbYxIKigYlcfD\n1jROTL7vmoz9RyrtCQhMf2SysUTBRjkq5Zr5RPtBsWDicityHL1qzrd3+kRknlqH\nR1AMd9nzI8Tbo5bc5XlsGyQk+v8ZXx0Qbh7/Zf4KbcNrb+wR866gJxogfD2l1PLG\nfSmYWTJqENPBCdgUs+kAA2QChJEdvj92Cp/hOV7te9AjnyzqodVdH4HH/CKwMwqU\nWAR5+EJsjJygD1cnBtB28ScOOnuA5fcqnuMb5l0qkzKWUJUcTaAoZ0H2HpZ9n6kT\nZWJsJP85fMQxA4FHtMtETz/vzIBYrtHYVjcf0g3TDX+imFWOFjBJwLaOzT8g1XfF\nGP8zD6NFAgMBAAECggEAHLf8yMRp6YlpIAQ3GDyB/paNVjup32iKsYgNylGElmfZ\nnlpYL72o1hwX/pPVghlh96/UV/alAHNVxXzSKJo2kAAVoEYg/OTOo2DFmzNOoUW9\nu7cDr1BUgs/w63bvv5ojxMkxMAn61WYbuZ3yeEdPq97JC7VhZ22WZ6cZ5PpOAich\nZP5nlnUs5Z1jEGtKsq3rolD1DutYVjztzuX2jDj6KrSFqH+SajGYVpCXGdxZ6DeW\npRxg5vo4id+8YUaDd9eGTw8F6ETIs5bctK8XrHYyG3MsGUuzp17dbkBYCvcOntpf\nye0DPQtCu87n2hUSbEAgNtjInEKjZOFDh2u6SNkdPQKBgQDhxs1WcIMB/1+XLC8d\nmFWVDWumsi/ScBrJ0aIu1tKrA1koVpC5L+YPlZLQFB2DjNNGPYCEXCjvYUbIfHV/\nDoNpIKppdd+HWdGPsJ9CBa4zP/+shCGjkBoeTBZqunR8gMm5mdVdLNpgOK6spX4x\nS62C6zz5YGQh9GftvR3+QjG0DwKBgQDaL+l9w5vrNozaq2vlLvKm9NcF1EaqnHP2\nbujjAcZ+eehalaBbSD0IYZ55Cu5BaByqrcCyJ1SKE7pV0QTCtYi5xrb72nJ9gKBr\nUd8PbO6ntTIKIawbkARKKatH0A0KJ0dA6NFG/DGNif7UbbOA2grBcdtNcmA5X+tl\nNrgWJvuPawKBgBKFPFLa5+RCDpVYCoVi+aJAd5Q1Cbc5evkTOTqeZKminK2ybCzE\nwRqGKoTnIYSpCKu6X9B7vt/kGupXS0wg5Ka7Bz+fa7aup4Ih+u5viNqrZU3BiQDh\n0UKq+yvGH8gWyHVxKQ97nm5GOA3xhWiFzLXwlg/e2FfwtJXL7antxCYBAoGAftLG\nt9GRueEVcq2do7PsW9uJeNvwz47tYNsLB5iqli2qP60lbqnIwCxt/xG5d89aimNA\n1M1DuJbLAsLiL4Nxm/rDthU943F2zarjK4Y4GseZ9IWqEsNdmvYply55xeMa6cHq\nk4ZYD1udAkFZy5XyFotl29iV0gPNQiHSUx4Jr00CgYAyoUrnyuqoi64FhTFIwbDs\nXtmDjuiyOjwxB3eqsKjj/Gd1GQPq2jDBsjAZiIxpPC6Wwg2AbNkrInmPoVkCUOCX\n9Y3agmCaM3tkQdLh8RKPL0Fe7zcDRAn57aTiogMuQRxlkLgstMjCPMpSoo9hodbi\nYQewVcoeIn3K6kjvwnZCvQ==\n-----END PRIVATE KEY-----\n",
        "client_email": "rishi-878@gsheet-384920.iam.gserviceaccount.com",
        "client_id": "109724932267120762752",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/rishi-878%40gsheet-384920.iam.gserviceaccount.com"


    });

    // Initialize Google Sheets API credentials and scopes

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
          final studentName = _studentNames[index];
          return Card(
            elevation: 2,
            color: Colors.white,

            child: Container(
              height: 80,

              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                title: Text(
                  _studentNames[index],
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    GestureDetector(
                      onTap: () async {

                        // Pass the index of the pressed icon to the function

                        await addAttendanceToGoogleSheet(_studentNames[index], DateTime.now(), true,widget.item);


                      },
                      child: Icon(Icons.check_circle_outline, color: Colors.green,size: 30,),
                    ),
                    SizedBox(width: 50),
                    GestureDetector(
                      onTap: () async {

                          // Pass the index of the pressed icon to the function

                        await addAttendanceToGoogleSheet(_studentNames[index], DateTime.now(), false,widget.item);


                      },
                      child: Icon(Icons.cancel_outlined, color: Colors.red,size: 30,),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          );

        },
      ),
    );
  }
  Future<void> addAttendanceToGoogleSheet(String studentName, DateTime currentDate,bool isPresent,ListItem item) async {
    // TODO: Replace with your own credentials file
    final sheetsApi = SheetsApi(await clientViaServiceAccount(_credentials, _scopes));



    // Authenticate with the Google Sheets API using the credentials
    final spreadsheetId = '1j65WDURjWjIk6n8_FURbwq7av4iU1elO1ET5EMW8RjE';
    final sheetName = item.title;
    final range = '$sheetName!A1:C1';
    var named = '';
    if(isPresent){
      named='Present';
    }
    if(!isPresent){
      named = 'Absent';
    }

    final valueRange = ValueRange.fromJson({
      'range': range,
      'majorDimension': 'ROWS',
      'values': [
        [studentName, named, DateTime.now().toString()],
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

    // Execute the request to add the new row to the sheet

  }
}





