import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_contract/widgets/home/controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        builder: (controller) => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: const [Colors.red, Colors.yellow],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Balance:  ₹ ${controller.balance}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      Text(
                        'Deposits:  ₹ ${controller.totalDeposits}',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  // deposit amount
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(fontSize: 20),
                          controller: controller.depositTextController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 8),
                        FlatButton.icon(
                          shape: const StadiumBorder(),
                          color: Colors.white,
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: controller.depositAmount,
                          label: const Text(
                            'Deposit',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // withdraw balance
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'withdraw_balance',
            onPressed: controller.withdrawBalance,
            label: const Text('Withdraw All'),
            icon: const Icon(Icons.remove_circle),
            backgroundColor: Colors.red,
          ),
        ),
      );
}
