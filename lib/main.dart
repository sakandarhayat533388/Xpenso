import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:xpenso/splash.dart';

import 'expenseModel.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive initialize
  Hive.registerAdapter(ExpenseAdapter()); // adapter register
  await Hive.openBox<Expense>('expensesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xpenso',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
        ),
      debugShowCheckedModeBanner: false,
      home: const splash()
    );
  }
}

