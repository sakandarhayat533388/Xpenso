import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:xpenso/addExpenses.dart';
import 'package:xpenso/color.dart';
import 'package:xpenso/customappbar.dart';
import 'package:xpenso/expenseCard.dart';
import 'package:xpenso/settings_screen.dart';
import 'package:xpenso/singleExpenseCard.dart';
import 'expenseModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = Hive.box<Expense>('expensesBox');

  double getTotalExpense() {
    double total = 0;

    for (var expense in box.values) {
      total += expense.amount;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Xpenso',
        showMenu: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            // 🔹 Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(color: primaryEnd),
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Xpenso',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage your expenses',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Menu Items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Expense'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Addexpense()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            const Spacer(),

            const Divider(),

            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<Expense> box, _) {
              double total = 0;
              for (var e in box.values) {
                total += e.amount;
              }
              return TotalExpenseCard(totalAmount: total);
            },
          ),

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
                  return Expanded(
                    child: const Center(child: Text('No expenses added yet')),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: expensesBox.length,
                  itemBuilder: (context, index) {
                    final expense = expensesBox.getAt(index)!;
                    return ExpenseCard(expense: expense, index: index);
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
