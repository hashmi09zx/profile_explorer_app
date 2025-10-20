import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/screens/home_screen.dart';
import 'viewmodel/profile_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..fetchUsers(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
