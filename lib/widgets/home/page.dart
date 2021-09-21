import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_contract/widgets/home/view.dart';

import 'controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        builder: (_) => const HomeView(),
        init: HomeController(),
      );
}
