const express = require('express');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Buat koneksi ke database MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Ganti dengan username MySQL Anda
  password: '', // Ganti dengan password MySQL Anda
  database: 'EsemkaLibrary'
});

// Cek koneksi ke database
db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database');
});

// Endpoint untuk mendapatkan semua buku
app.get('/books', (req, res) => {
  const query = `
    SELECT b.*, 
           IFNULL(DATEDIFF(NOW(), br.borrow_date), 0) AS days_borrowed
    FROM Book b
    LEFT JOIN Borrowing br ON b.id = br.book_id AND br.return_date IS NULL
    WHERE b.deleted_at IS NULL
  `;
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Endpoint untuk mendapatkan data peminjaman berdasarkan member
app.get('/borrowings/:memberId', (req, res) => {
  const memberId = req.params.memberId;
  const query = `
    SELECT br.id, b.title, br.borrow_date, br.due_date, br.return_date, br.fine, m.name,
           DATEDIFF(NOW(), br.borrow_date) AS days_borrowed
    FROM Borrowing br
    JOIN Book b ON br.book_id = b.id
    JOIN Member m ON br.member_id = m.id
    WHERE br.member_id = ? AND br.deleted_at IS NULL
  `;
  db.query(query, [memberId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Endpoint untuk mendapatkan riwayat peminjaman berdasarkan member
app.get('/borrowing-history/:memberId', (req, res) => {
  const memberId = req.params.memberId;
  const query = `
    SELECT brh.id, b.title, brh.borrow_date, brh.return_date, brh.fine, m.name 
    FROM BorrowingHistory brh
    JOIN Book b ON brh.book_id = b.id
    JOIN Member m ON brh.member_id = m.id
    WHERE brh.member_id = ? AND brh.deleted_at IS NULL
  `;
  db.query(query, [memberId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Endpoint untuk mencari user berdasarkan nama
app.get('/users', (req, res) => {
  const name = req.query.name;
  const query = 'SELECT id, name FROM Member WHERE name LIKE ? AND deleted_at IS NULL';
  db.query(query, [`%${name}%`], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Endpoint untuk meminjam buku
app.post('/borrow', (req, res) => {
  const { memberId, bookId } = req.body;

  // Check book stock
  const checkStockQuery = 'SELECT stock FROM Book WHERE id = ? AND deleted_at IS NULL';
  db.query(checkStockQuery, [bookId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0 || results[0].stock <= 0) {
      return res.status(400).json({ error: 'Book is out of stock' });
    }

    // Check borrowing limit (max 3 books)
    const checkBorrowingLimitQuery = 'SELECT COUNT(*) AS count FROM Borrowing WHERE member_id = ? AND return_date IS NULL';
    db.query(checkBorrowingLimitQuery, [memberId], (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results[0].count >= 3) {
        return res.status(400).json({ error: 'Member has reached the borrowing limit' });
      }

      // Process borrowing
      const borrowQuery = `
        INSERT INTO Borrowing (member_id, book_id, borrow_date, due_date)
        VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY))
      `;
      db.query(borrowQuery, [memberId, bookId], (err, results) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }

        // Decrease book stock
        const updateStockQuery = 'UPDATE Book SET stock = stock - 1 WHERE id = ?';
        db.query(updateStockQuery, [bookId], (err, results) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.json({ message: 'Book borrowed successfully' });
        });
      });
    });
  });
});

// Endpoint untuk mengembalikan buku
app.post('/return', (req, res) => {
  const { borrowingId } = req.body;

  // Check borrowing data
  const checkBorrowingQuery = 'SELECT * FROM Borrowing WHERE id = ? AND return_date IS NULL';
  db.query(checkBorrowingQuery, [borrowingId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(400).json({ error: 'Borrowing record not found or already returned' });
    }

    const borrowing = results[0];
    const dueDate = new Date(borrowing.due_date);
    const returnDate = new Date();
    const overdueDays = Math.max(0, Math.floor((returnDate - dueDate) / (1000 * 60 * 60 * 24))); // Calculate overdue days
    const fine = overdueDays * 2000; // Fine 2000 IDR per day

    // Update return data
    const returnQuery = `
      UPDATE Borrowing
      SET return_date = NOW(), fine = ?
      WHERE id = ?
    `;
    db.query(returnQuery, [fine, borrowingId], (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }

      // Increase book stock
      const updateStockQuery = 'UPDATE Book SET stock = stock + 1 WHERE id = ?';
      db.query(updateStockQuery, [borrowing.book_id], (err, results) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }

        // Move data to BorrowingHistory
        const moveToHistoryQuery = `
          INSERT INTO BorrowingHistory (member_id, book_id, borrow_date, return_date, fine)
          SELECT member_id, book_id, borrow_date, NOW(), fine
          FROM Borrowing
          WHERE id = ?
        `;
        db.query(moveToHistoryQuery, [borrowingId], (err, results) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }

          // Delete data from Borrowing
          const deleteBorrowingQuery = 'DELETE FROM Borrowing WHERE id = ?';
          db.query(deleteBorrowingQuery, [borrowingId], (err, results) => {
            if (err) {
              return res.status(500).json({ error: err.message });
            }
            res.json({ message: 'Book returned successfully', fine });
          });
        });
      });
    });
  });
});

// END point untuk warna ketika user meminjam

// Endpoint untuk menambah data peminjaman
app.post('/borrowings', (req, res) => {
  const { memberId, bookId } = req.body;
  const query = `
    INSERT INTO Borrowing (member_id, book_id, borrow_date, due_date)
    VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY))
  `;
  db.query(query, [memberId, bookId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Borrowing added successfully', borrowingId: results.insertId });
  });
});

// Endpoint untuk memperbarui data peminjaman
app.put('/borrowings/:borrowingId', (req, res) => {
  const borrowingId = req.params.borrowingId;
  const { dueDate } = req.body;
  const query = 'UPDATE Borrowing SET due_date = ? WHERE id = ? AND return_date IS NULL';
  db.query(query, [dueDate, borrowingId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Borrowing updated successfully' });
  });
});

// Endpoint untuk memperbarui jumlah hari peminjaman
app.put('/borrowings/:borrowingId/days', (req, res) => {
  const borrowingId = req.params.borrowingId;
  const { days } = req.body;
  const query = 'UPDATE Borrowing SET borrow_date = DATE_SUB(due_date, INTERVAL ? DAY) WHERE id = ? AND return_date IS NULL';
  db.query(query, [days, borrowingId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Borrowing days updated successfully' });
  });
});

// Endpoint untuk menghapus data peminjaman
app.delete('/borrowings/:borrowingId', (req, res) => {
  const borrowingId = req.params.borrowingId;
  const query = 'DELETE FROM Borrowing WHERE id = ? AND return_date IS NULL';
  db.query(query, [borrowingId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Borrowing deleted successfully' });
  });
});

// Endpoint untuk menambah buku baru
app.post('/books', (req, res) => {
  const { title, author, stock } = req.body;
  const query = 'INSERT INTO Book (title, author, stock) VALUES (?, ?, ?)';
  db.query(query, [title, author, stock], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Book added successfully', bookId: results.insertId });
  });
});

// Endpoint untuk memperbarui informasi buku
app.put('/books/:bookId', (req, res) => {
  const bookId = req.params.bookId;
  const { title, author, stock } = req.body;
  const query = 'UPDATE Book SET title = ?, author = ?, stock = ? WHERE id = ? AND deleted_at IS NULL';
  db.query(query, [title, author, stock, bookId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Book updated successfully' });
  });
});

// Endpoint untuk menghapus buku
app.delete('/books/:bookId', (req, res) => {
  const bookId = req.params.bookId;
  const query = 'UPDATE Book SET deleted_at = NOW() WHERE id = ?';
  db.query(query, [bookId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Book deleted successfully' });
  });
});

// Jalankan server
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});