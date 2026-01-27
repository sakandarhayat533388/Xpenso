import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:xpenso/addExpenses.dart';
import 'package:xpenso/color.dart';
import 'package:xpenso/customappbar.dart';
import 'package:xpenso/expenseCard.dart';
import 'package:xpenso/singleExpenseCard.dart';

import 'expenseModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = Hive.box<Expense>('expensesBox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Xpenso'),
      body:  Column(
        children: [
          const SizedBox(height: 10),

          TotalExpenseCard(totalAmount: 120000),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent Expenses',
              style: TextStyle(color: textSecondary, fontSize: 16),
            ),
          ),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Expense> expensesBox, _) {

                if (expensesBox.isEmpty) {
                  return const Center(
                    child: Text('No expenses added yet'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: expensesBox.length,
                  itemBuilder: (context, index) {
                    final expense = expensesBox.getAt(index)!;

                    return ExpenseCard(
                      expense: expense,
                      index: index,
                    );
                  },
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
            MaterialPageRoute(builder: (context) => Addexpense()),
          );
        },
        backgroundColor: primaryStart,
        elevation: 6,
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }
}
