import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_contract/widgets/home/page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Smart Contract',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
