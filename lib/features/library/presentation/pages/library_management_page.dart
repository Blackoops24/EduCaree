import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class LibraryManagementPage extends StatefulWidget {
  const LibraryManagementPage({super.key});

  @override
  State<LibraryManagementPage> createState() => _LibraryManagementPageState();
}

class _LibraryManagementPageState extends State<LibraryManagementPage> {
  final List<BookCategory> _categories = [
    BookCategory(id: 1, name: 'Fiction', description: 'Novels, stories and literature'),
    BookCategory(id: 2, name: 'Science', description: 'Science, technology, and reference books'),
    BookCategory(id: 3, name: 'History', description: 'Historical books and biographies'),
  ];

  final List<LibraryBook> _books = [
    LibraryBook(
      id: 1,
      title: 'The Secret Garden',
      author: 'Frances Hodgson Burnett',
      category: 'Fiction',
      isbn: '9780141321103',
      totalCopies: 5,
      availableCopies: 4,
    ),
    LibraryBook(
      id: 2,
      title: 'A Brief History of Time',
      author: 'Stephen Hawking',
      category: 'Science',
      isbn: '9780553380163',
      totalCopies: 3,
      availableCopies: 1,
    ),
    LibraryBook(
      id: 3,
      title: 'The Diary of a Young Girl',
      author: 'Anne Frank',
      category: 'History',
      isbn: '9780553296983',
      totalCopies: 4,
      availableCopies: 2,
    ),
  ];

  final List<BookIssue> _issues = [
    BookIssue(
      id: 1,
      bookTitle: 'A Brief History of Time',
      studentName: 'Riya Mehta',
      issueDate: '2026-06-01',
      dueDate: '2026-06-15',
      returned: false,
      returnDate: null,
    ),
    BookIssue(
      id: 2,
      bookTitle: 'The Diary of a Young Girl',
      studentName: 'Ishaan Patel',
      issueDate: '2026-05-10',
      dueDate: '2026-05-24',
      returned: true,
      returnDate: '2026-05-25',
    ),
  ];

  final List<FineRecord> _fines = [];

  static const finePerDay = 10.0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Inventory'),
              Tab(text: 'Issue Books'),
              Tab(text: 'Return Books'),
              Tab(text: 'Fines'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoryTab(context),
            _buildInventoryTab(context),
            _buildIssueTab(context),
            _buildReturnTab(context),
            _buildFinesTab(context),
            _buildReportsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, {VoidCallback? action, String? actionLabel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (action != null && actionLabel != null)
            ElevatedButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Book Categories', 'Manage categories used by the library.', action: () => _showCategoryDialog(context), actionLabel: 'Add Category'),
        Expanded(
          child: _categories.isEmpty
              ? const Center(child: Text('No categories have been created yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(category.name),
                        subtitle: Text(category.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showCategoryDialog(context, category: category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete book category?',
                                  message: 'This will remove ${category.name} from book categories.',
                                );
                                if (!confirmed) return;
                                setState(() => _categories.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInventoryTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Book Inventory', 'Track book stock and availability.', action: () => _showBookDialog(context), actionLabel: 'Add Book'),
        Expanded(
          child: _books.isEmpty
              ? const Center(child: Text('No books in inventory yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _books.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text('${book.author} • ${book.category} • ISBN ${book.isbn}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Available: ${book.availableCopies}'),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showBookDialog(context, book: book)),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmed = await showDeleteConfirmationDialog(
                                      context,
                                      title: 'Delete book?',
                                      message: 'This will remove ${book.title} from library inventory.',
                                    );
                                    if (!confirmed) return;
                                    setState(() => _books.removeAt(index));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildIssueTab(BuildContext context) {
    final availableBooks = _books.where((book) => book.availableCopies > 0).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Issue Books', 'Assign books to students and track due dates.', action: () => _showIssueDialog(context), actionLabel: 'Issue Book'),
        Expanded(
          child: availableBooks.isEmpty
              ? const Center(child: Text('No books are currently available for issue.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: availableBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final book = availableBooks[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text('${book.author} • ${book.category} • Available: ${book.availableCopies}'),
                        trailing: ElevatedButton(
                          onPressed: () => _showIssueDialog(context, book: book),
                          child: const Text('Issue'),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReturnTab(BuildContext context) {
    final issuedBooks = _issues.where((issue) => !issue.returned).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Return Books', 'Return issued books and calculate late fees.', action: () {}, actionLabel: null),
        Expanded(
          child: issuedBooks.isEmpty
              ? const Center(child: Text('No books are currently issued.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: issuedBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final issue = issuedBooks[index];
                    final overdueDays = _calculateOverdueDays(issue.dueDate);
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(issue.bookTitle),
                        subtitle: Text('${issue.studentName} • Due ${issue.dueDate} • ${overdueDays > 0 ? '$overdueDays days overdue' : 'On schedule'}'),
                        trailing: ElevatedButton(
                          onPressed: () => _returnBook(issue),
                          child: const Text('Return'),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFinesTab(BuildContext context) {
    final unpaidFines = _fines.where((fine) => !fine.paid).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Fine Calculation', 'Review overdue fines and settle dues.'),
        Expanded(
          child: unpaidFines.isEmpty
              ? const Center(child: Text('No unpaid fines at the moment.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: unpaidFines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final fine = unpaidFines[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('Fine for ${fine.issue.bookTitle}'),
                        subtitle: Text('${fine.issue.studentName} • ₹${fine.amount.toStringAsFixed(0)}'),
                        trailing: ElevatedButton(
                          onPressed: () => setState(() => fine.paid = true),
                          child: const Text('Settle'),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    final issuedCount = _issues.length;
    final overdueIssues = _issues.where((issue) => !_isReturned(issue) && _calculateOverdueDays(issue.dueDate) > 0).toList();
    final overdueCount = overdueIssues.length;
    final activeIssues = _issues.where((issue) => !issue.returned).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Library Reports', 'Issued books and overdue status at a glance.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ReportCard(title: 'Total Issues', value: '$issuedCount'),
              _ReportCard(title: 'Active Issues', value: '${activeIssues.length}'),
              _ReportCard(title: 'Overdue Books', value: '$overdueCount'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Issued Books', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._issues.map((issue) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(issue.bookTitle),
                  subtitle: Text('${issue.studentName} • Issued ${issue.issueDate} • Due ${issue.dueDate}'),
                  trailing: Text(issue.returned ? 'Returned' : 'Issued'),
                ),
              )),
          const SizedBox(height: 24),
          const Text('Overdue Books', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          overdueIssues.isEmpty
              ? const Text('No overdue books at this time.')
              : Column(
                  children: overdueIssues
                      .map((issue) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(issue.bookTitle),
                              subtitle: Text('${issue.studentName} • Due ${issue.dueDate} • ${_calculateOverdueDays(issue.dueDate)} days overdue'),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, {BookCategory? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController = TextEditingController(text: category?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Category Name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category name is required.')));
                return;
              }
              setState(() {
                if (category != null) {
                  category.name = name;
                  category.description = description;
                } else {
                  _categories.add(BookCategory(
                    id: _categories.isEmpty ? 1 : _categories.last.id + 1,
                    name: name,
                    description: description,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBookDialog(BuildContext context, {LibraryBook? book}) {
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final isbnController = TextEditingController(text: book?.isbn ?? '');
    final totalCopiesController = TextEditingController(text: book?.totalCopies.toString() ?? '');
    String selectedCategory = book?.category ?? _categories.first.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book == null ? 'Add Book' : 'Edit Book'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: authorController, decoration: const InputDecoration(labelText: 'Author')),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: _categories.map((category) => DropdownMenuItem(value: category.name, child: Text(category.name))).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) => selectedCategory = value ?? selectedCategory,
              ),
              TextField(controller: isbnController, decoration: const InputDecoration(labelText: 'ISBN')),
              TextField(controller: totalCopiesController, decoration: const InputDecoration(labelText: 'Total Copies'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final author = authorController.text.trim();
              final isbn = isbnController.text.trim();
              final totalCopies = int.tryParse(totalCopiesController.text.trim()) ?? 0;
              if (title.isEmpty || author.isEmpty || isbn.isEmpty || totalCopies <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid book details.')));
                return;
              }
              setState(() {
                if (book != null) {
                  book.title = title;
                  book.author = author;
                  book.category = selectedCategory;
                  book.isbn = isbn;
                  book.totalCopies = totalCopies;
                  book.availableCopies = book.availableCopies > totalCopies ? totalCopies : book.availableCopies;
                } else {
                  _books.add(LibraryBook(
                    id: _books.isEmpty ? 1 : _books.last.id + 1,
                    title: title,
                    author: author,
                    category: selectedCategory,
                    isbn: isbn,
                    totalCopies: totalCopies,
                    availableCopies: totalCopies,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showIssueDialog(BuildContext context, {LibraryBook? book}) {
    final studentController = TextEditingController();
    final issueDateController = TextEditingController(text: DateTime.now().toString().split(' ').first);
    final dueDateController = TextEditingController(text: DateTime.now().add(const Duration(days: 14)).toString().split(' ').first);
    String selectedBook = book?.title ?? (_books.isNotEmpty ? _books.first.title : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Issue Book'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedBook.isNotEmpty ? selectedBook : null,
                items: _books.where((item) => item.availableCopies > 0).map((item) => DropdownMenuItem(value: item.title, child: Text(item.title))).toList(),
                decoration: const InputDecoration(labelText: 'Book'),
                onChanged: (value) => selectedBook = value ?? selectedBook,
              ),
              const SizedBox(height: 8),
              TextField(controller: studentController, decoration: const InputDecoration(labelText: 'Student Name')),
              const SizedBox(height: 8),
              TextField(controller: issueDateController, decoration: const InputDecoration(labelText: 'Issue Date')),
              const SizedBox(height: 8),
              TextField(controller: dueDateController, decoration: const InputDecoration(labelText: 'Due Date')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final studentName = studentController.text.trim();
              final issueDate = issueDateController.text.trim();
              final dueDate = dueDateController.text.trim();
              if (selectedBook.isEmpty || studentName.isEmpty || issueDate.isEmpty || dueDate.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid issue details.')));
                return;
              }
              final selected = _books.firstWhere((item) => item.title == selectedBook);
              if (selected.availableCopies <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selected book is not available.')));
                return;
              }
              setState(() {
                selected.availableCopies -= 1;
                _issues.add(BookIssue(
                  id: _issues.isEmpty ? 1 : _issues.last.id + 1,
                  bookTitle: selected.title,
                  studentName: studentName,
                  issueDate: issueDate,
                  dueDate: dueDate,
                  returned: false,
                  returnDate: null,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Issue'),
          ),
        ],
      ),
    );
  }

  void _returnBook(BookIssue issue) {
    final book = _books.firstWhere((item) => item.title == issue.bookTitle, orElse: () => LibraryBook(id: 0, title: issue.bookTitle, author: 'Unknown', category: issue.bookTitle, isbn: '', totalCopies: 0, availableCopies: 0));
    final returnDate = DateTime.now();
    final dueDate = DateTime.parse(issue.dueDate);
    final overdueDays = returnDate.difference(dueDate).inDays;
    setState(() {
      issue.returned = true;
      issue.returnDate = returnDate.toString().split(' ').first;
      if (book.id != 0) {
        book.availableCopies += 1;
      }
      if (overdueDays > 0) {
        _fines.add(FineRecord(issue: issue, amount: overdueDays * finePerDay, paid: false));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book returned successfully.')));
  }

  int _calculateOverdueDays(String dueDate) {
    final due = DateTime.tryParse(dueDate);
    if (due == null) return 0;
    final daysOverdue = DateTime.now().difference(due).inDays;
    return daysOverdue > 0 ? daysOverdue : 0;
  }

  bool _isReturned(BookIssue issue) => issue.returned;
}

class BookCategory {
  BookCategory({required this.id, required this.name, required this.description});

  final int id;
  String name;
  String description;
}

class LibraryBook {
  LibraryBook({required this.id, required this.title, required this.author, required this.category, required this.isbn, required this.totalCopies, required this.availableCopies});

  final int id;
  String title;
  String author;
  String category;
  String isbn;
  int totalCopies;
  int availableCopies;
}

class BookIssue {
  BookIssue({required this.id, required this.bookTitle, required this.studentName, required this.issueDate, required this.dueDate, required this.returned, this.returnDate});

  final int id;
  final String bookTitle;
  final String studentName;
  final String issueDate;
  final String dueDate;
  bool returned;
  String? returnDate;
}

class FineRecord {
  FineRecord({required this.issue, required this.amount, required this.paid});

  final BookIssue issue;
  final double amount;
  bool paid;
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;

  const _ReportCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
