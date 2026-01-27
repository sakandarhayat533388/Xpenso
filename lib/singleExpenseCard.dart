import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'editExpense.dart'; // ye screen jahan edit logic hai
import 'expenseModel.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final int index;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(  // <-- Tap ke liye InkWell ya GestureDetector use karo
      onTap: () {
        // Navigate to EditExpenseScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditExpenseScreen(
              expense: expense,
              index: index,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Left side: Title, Category, Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(expense.category),
                  const SizedBox(height: 4),
                  Text(
                    // date format
                    DateFormat('dd MMM yyyy').format(expense.date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              // Right side: Amount
              Text(
                'Rs ${expense.amount}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
