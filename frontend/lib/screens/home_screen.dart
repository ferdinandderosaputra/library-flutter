import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/borrowing_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> books = [];
  bool isLoading = true;
  List<dynamic> users = [];
  int? selectedUserId;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/books'));
      if (response.statusCode == 200) {
        setState(() {
          books = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books: $e')),
      );
    }
  }

  Future<void> searchUsers(String name) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/users?name=$name'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> borrowBook(int bookId) async {
    if (selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a user first')),
      );
      return;
    }
    final response = await http.post(
      Uri.parse('http://localhost:5000/borrow'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'memberId': selectedUserId, 'bookId': bookId}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book borrowed successfully')),
      );
      fetchBooks(); // Refresh book data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to borrow book: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> addBook(String title, String author, int stock) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/books'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'author': author, 'stock': stock}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book added successfully')),
      );
      fetchBooks(); // Refresh data buku
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add book: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> updateBook(int bookId, String title, String author, int stock) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/books/$bookId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'author': author, 'stock': stock}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book updated successfully')),
      );
      fetchBooks(); // Refresh data buku
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update book: ${json.decode(response.body)['error']}')),
      );
    }
  }

  Future<void> deleteBook(int bookId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5000/books/$bookId'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book deleted successfully')),
      );
      fetchBooks(); // Refresh data buku
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete book: ${json.decode(response.body)['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esemka Library'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BorrowingScreen(memberId: selectedUserId ?? 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search User by Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchUsers(value);
                } else {
                  setState(() {
                    users = [];
                  });
                }
              },
            ),
          ),
          if (users.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['name']),
                    onTap: () {
                      setState(() {
                        selectedUserId = user['id'];
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected user: ${user['name']}')),
                      );
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String title = '';
                    String author = '';
                    int stock = 0;
                    return AlertDialog(
                      title: Text('Add Book'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: 'Title'),
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Author'),
                            onChanged: (value) {
                              author = value;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Stock'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              stock = int.parse(value);
                            },
                          ),
                        ],
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
                            addBook(title, author, stock);
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Book'),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return ListTile(
                        title: Text(book['title']),
                        subtitle: Text('Author: ${book['author']} - Stock: ${book['stock']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String title = book['title'];
                                    String author = book['author'];
                                    int stock = book['stock'];
                                    return AlertDialog(
                                      title: Text('Edit Book'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(labelText: 'Title'),
                                            onChanged: (value) {
                                              title = value;
                                            },
                                            controller: TextEditingController(text: book['title']),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(labelText: 'Author'),
                                            onChanged: (value) {
                                              author = value;
                                            },
                                            controller: TextEditingController(text: book['author']),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(labelText: 'Stock'),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              stock = int.parse(value);
                                            },
                                            controller: TextEditingController(text: book['stock'].toString()),
                                          ),
                                        ],
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
                                            updateBook(book['id'], title, author, stock);
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
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteBook(book['id']),
                            ),
                            IconButton(
                              icon: Icon(Icons.book),
                              onPressed: () => borrowBook(book['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BorrowingScreen(memberId: selectedUserId ?? 1),
            ),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}