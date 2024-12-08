import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restapi_todo/theme/theme_provider.dart';

import 'screens/todo_list.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}