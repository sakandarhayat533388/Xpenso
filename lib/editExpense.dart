import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpenso/customappbar.dart';
import 'expenseModel.dart';
import 'package:hive/hive.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense; // ye woh expense hai jisko edit karna hai
  final int index; // Hive box me position

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.index,
  });

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
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _categoryController = TextEditingController(text: widget.expense.category);
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(widget.expense.date),
    );
    selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Expense', showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Expense title',
                prefixIcon: const Icon(Icons.edit),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                prefixIcon: const Icon(Icons.currency_rupee),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            TextField(
              controller: _categoryController,
              readOnly: true,
              onTap: _pickCategory,
              decoration: InputDecoration(
                hintText: 'Select category',
                prefixIcon: const Icon(Icons.category),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                hintText: 'Select date',
                prefixIcon: const Icon(Icons.calendar_today),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
              ),
              child: InkWell(
                onTap: _saveExpense,
                child: Center(
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red
              ),
              child: InkWell(
                onTap: _deleteExpense,
                child: Center(
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
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
              title: const Text("Travel"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Travel";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Shopping"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Shopping";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text("Bills"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Bills";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text("Entertainment"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Entertainment";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Other"),
              onTap: () {
                setState(() {
                  _categoryController.text = "Other";
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Padding(
          padding: EdgeInsets.symmetric(vertical: 20), // 👈 height yahin se
          child: Center(child: Text("Please fill all fields correctly")),
        ),

          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
          ),
          padding: EdgeInsets.symmetric(vertical: 10),),

      );
      return;
    }

    final box = Hive.box<Expense>('expensesBox');
    box.putAt(
      widget.index,
      Expense(title: title, amount: amount, category: category, date: date),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Padding(
        padding: EdgeInsets.symmetric(vertical: 20), // 👈 height yahin se
        child: Text("Successfully Saved"),
      ),

        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
        ),),

    );
    Navigator.pop(context);
  }

  void _deleteExpense() {
    final box = Hive.box<Expense>('expensesBox');
    box.deleteAt(widget.index);
    Navigator.pop(context);
  }
}
