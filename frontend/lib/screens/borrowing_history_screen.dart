import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BorrowingHistoryScreen extends StatefulWidget {
  final int memberId;

  BorrowingHistoryScreen({required this.memberId});

  @override
  _BorrowingHistoryScreenState createState() => _BorrowingHistoryScreenState();
}

class _BorrowingHistoryScreenState extends State<BorrowingHistoryScreen> {
  List<dynamic> borrowingHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBorrowingHistory();
  }

  Future<void> fetchBorrowingHistory() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/borrowing-history/${widget.memberId}'));
      if (response.statusCode == 200) {
        setState(() {
          borrowingHistory = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load borrowing history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load borrowing history: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowing History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: borrowingHistory.length,
              itemBuilder: (context, index) {
                final history = borrowingHistory[index];
                final daysBorrowed = DateTime.now().difference(DateTime.parse(history['borrow_date'])).inDays;
                final fine = daysBorrowed > 7 ? (daysBorrowed - 7) * 2000 : 0;
                return ListTile(
                  title: Text(history['title']),
                  subtitle: Text('Borrow Date: ${history['borrow_date']} - Return Date: ${history['return_date']} - Borrowed by: ${history['name']}'),
                  trailing: Text('Fine: $fine IDR'),
                  tileColor: daysBorrowed > 7 ? Colors.red : (daysBorrowed > 5 ? Colors.yellow : null),
                );
              },
            ),
    );
  }
}
