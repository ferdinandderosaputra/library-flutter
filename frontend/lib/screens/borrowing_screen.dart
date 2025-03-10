import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'borrowing_history_screen.dart'; // Add this line

class BorrowingScreen extends StatefulWidget {
  final int memberId;

  BorrowingScreen({required this.memberId});

  @override
  _BorrowingScreenState createState() => _BorrowingScreenState();
}

class _BorrowingScreenState extends State<BorrowingScreen> {
  List<dynamic> borrowings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBorrowings();
  }

  Future<void> fetchBorrowings() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/borrowings/${widget.memberId}'));
      if (response.statusCode == 200) {
        setState(() {
          borrowings = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load borrowings');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load borrowings: $e')),
      );
    }
  }

  Future<void> returnBook(int borrowingId) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/return'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'borrowingId': borrowingId}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book returned successfully. Fine: ${json.decode(response.body)['fine']} IDR')),
      );
      fetchBorrowings(); // Refresh borrowing data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to return book: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> addBorrowing(int memberId, int bookId) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/borrow'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'memberId': memberId, 'bookId': bookId}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Borrowing added successfully')),
      );
      fetchBorrowings(); // Refresh borrowing data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add borrowing: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> updateBorrowing(int borrowingId, DateTime dueDate) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/borrowings/$borrowingId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'dueDate': dueDate.toIso8601String()}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Borrowing updated successfully')),
      );
      fetchBorrowings(); // Refresh borrowing data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update borrowing: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> deleteBorrowing(int borrowingId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5000/borrowings/$borrowingId'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Borrowing deleted successfully')),
      );
      fetchBorrowings(); // Refresh borrowing data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete borrowing: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> _selectDueDate(BuildContext context, int borrowingId, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      updateBorrowing(borrowingId, picked);
    }
  }

  Future<void> updateBorrowingDays(int borrowingId, int days) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/borrowings/$borrowingId/days'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'days': days}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Borrowing days updated successfully')),
      );
      fetchBorrowings(); // Refresh borrowing data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update borrowing days: ${json.decode(response.body)['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowing Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BorrowingHistoryScreen(memberId: widget.memberId),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: borrowings.length,
              itemBuilder: (context, index) {
                final borrowing = borrowings[index];
                final daysBorrowed = DateTime.now().difference(DateTime.parse(borrowing['borrow_date'])).inDays;
                final fine = daysBorrowed > 7 ? (daysBorrowed - 7) * 2000 : 0;
                return ListTile(
                  title: Text(borrowing['title']),
                  subtitle: Text('Borrow Date: ${borrowing['borrow_date']} - Due Date: ${borrowing['due_date']} - Borrowed by: ${borrowing['name']} - Days Borrowed: ${borrowing['days_borrowed']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      borrowing['return_date'] == null
                          ? IconButton(
                              icon: Icon(Icons.undo),
                              onPressed: () => returnBook(borrowing['id']),
                            )
                          : Text('Returned'),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _selectDueDate(context, borrowing['id'], DateTime.parse(borrowing['due_date']));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteBorrowing(borrowing['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              int days = borrowing['days_borrowed'];
                              return AlertDialog(
                                title: Text('Edit Borrowed Days'),
                                content: TextField(
                                  decoration: InputDecoration(labelText: 'Days'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    days = int.parse(value);
                                  },
                                  controller: TextEditingController(text: days.toString()),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      updateBorrowingDays(borrowing['id'], days);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  tileColor: daysBorrowed > 7 ? Colors.red : (daysBorrowed > 5 ? Colors.yellow : null),
                );
              },
            ),
    );
  }
}