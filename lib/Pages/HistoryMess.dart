import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Util/HexToColor.dart';
import '../Util/httpCalls.dart';
import 'RequestSent.dart';

class HistoryMess extends StatefulWidget {
  HistoryMess(this.secKey);
  final String secKey;

  @override
  _HistoryMessState createState() => _HistoryMessState();
}

class _HistoryMessState extends State<HistoryMess> {
  List<Map<String, dynamic>> messHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchMessHistory();
  }

  Future<void> _fetchMessHistory() async {
    final url = "$httpUrl/dashboard/${widget.secKey}/D/";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        messHistory = List<Map<String, dynamic>>.from(responseBody);
      });
    } else {
      print("Failed to fetch mess history. ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: HexColor("#637892"),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                color: HexColor("#637892"),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: HexColor("#F7F7F7"),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100)),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messHistory.length,
              itemBuilder: (context, index) {
                final history = messHistory[index];
                final dateAdded = history['date_added'] ?? '';
                final dateCompleted = history['date_completed'] ?? '';
                final empID = history['cleaner_ID'] ?? '';
                final isCompleted = history['is_completed'] ?? false;

                final trimmedDateAdded = dateAdded.substring(0, 10);
                final trimmedDateCompleted = dateCompleted.length >= 13
                    ? dateCompleted.substring(0, 13)
                    : "NOT COMPLETED";
                final serialNumber = (index + 1).toString().padLeft(2, '0');

                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  width: 360,
                  decoration: BoxDecoration(
                    color: HexColor("#D9D9D9"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "S.No: $serialNumber",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Date Added: $trimmedDateAdded",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            isCompleted == false
                                ? "Date Completed: $trimmedDateCompleted"
                                : "Not Completed",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "Emp ID: $empID",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
