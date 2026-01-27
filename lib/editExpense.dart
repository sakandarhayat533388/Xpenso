import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expenseModel.dart';
import 'package:hive/hive.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense; // ye woh expense hai jisko edit karna hai
  final int index; // Hive box me position

  const EditExpenseScreen({super.key, required this.expense, required this.index});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _dateController;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _categoryController = TextEditingController(text: widget.expense.category);
    _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(widget.expense.date));
    selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 16),

            // Category
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
              readOnly: true,
              onTap: _pickCategory,
            ),
            const SizedBox(height: 16),

            // Date
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveExpense,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.deepPurple, // gradient can be added using Container if needed
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteExpense,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete Expense', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void _pickCategory() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.fastfood),
              title: const Text("Food"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Food";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text("Transport"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Transport";
                });
                Navigator.pop(context);
              },
            ),
            // aur categories add kar sakte ho
          ],
        );
      },
    );
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _saveExpense() {
    String title = _titleController.text.trim();
    String category = _categoryController.text.trim();
    double? amount = double.tryParse(_amountController.text.trim());
    DateTime date = selectedDate ?? DateTime.now();

    if (title.isEmpty || category.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields correctly")));
      return;
    }

    final box = Hive.box<Expense>('expensesBox');
    box.putAt(widget.index, Expense(title: title, amount: amount, category: category, date: date));
    Navigator.pop(context);
  }

  void _deleteExpense() {
    final box = Hive.box<Expense>('expensesBox');
    box.deleteAt(widget.index);
    Navigator.pop(context);
  }
}
