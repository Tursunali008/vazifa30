import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vazifa30/screen/product_screen.dart';
import 'package:vazifa30/services/app_servise.dart';
import 'bloc/product_bloc.dart';
import 'bloc/product_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(ApiService())..add(LoadProducts()),
      child: MaterialApp(
        title: 'Online Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const ProductPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}