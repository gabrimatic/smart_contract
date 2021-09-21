import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class HomeController extends GetxController {
  final depositTextController = TextEditingController(text: '3');
  int balance = 0, totalDeposits = 0;
  late Web3Client ethClient;
  String? abi;
  EthereumAddress? contractAddress;
  String privateKey =
      '763d2bee99ac2d0cddbba3867e49b73b696ee708719fe236bebfe98e85cd0a2c';
  late Credentials credentials;
  late EthereumAddress myAddress;
  late DeployedContract contract;
  late ContractFunction _getBalanceAmount,
      _getDepositAmount,
      _addDepositAmount,
      _withdrawBalance;

  @override
  void onInit() {
    initialSetup();
    super.onInit();
  }

  Future<void> initialSetup() async {
    ethClient = Web3Client('http://10.0.2.2:7545', Client());
    await getCredentials();
    await getDeployedContract();
    await getContractFunctions();
  }

  Future<void> getCredentials() async {
    // credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    credentials = EthPrivateKey.fromHex(privateKey);
    myAddress = await credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    String abiString = await rootBundle.loadString('src/abis/Investment.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress = EthereumAddress.fromHex(
      abiJson['networks']['5777']['address'],
    );
  }

  Future<void> getContractFunctions() async {
    contract = DeployedContract(
      ContractAbi.fromJson(abi!, "Investment"),
      contractAddress!,
    );

    _getBalanceAmount = contract.function('getBalanceAmount');
    _getDepositAmount = contract.function('getDepositAmount');
    _addDepositAmount = contract.function('addDepositAmount');
    _withdrawBalance = contract.function('withdrawBalance');

    checkDeposit();
    checkBalance();
  }

  /// This will call a [functionName] with [functionArgs] as parameters
  /// defined in the [contract] and returns its result
  Future<List<dynamic>> readContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    var queryResult = await ethClient.call(
      contract: contract,
      function: functionName,
      params: functionArgs,
    );

    return queryResult;
  }

  /// Signs the given transaction using the keys supplied in the [credentials] object
  /// to upload it to the client so that it can be executed
  Future<void> writeContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: functionName,
        parameters: functionArgs,
      ),
    );
  }

  Future<void> checkBalance() async {
    var result = await readContract(
      _getBalanceAmount,
      [],
    );
    balance = result.first?.toInt();
    update();
  }

  Future<void> checkDeposit() async {
    final result = await readContract(_getDepositAmount, []);
    totalDeposits = result.first?.toInt();
    update();
  }

  Future<void> depositAmount() async {
    if (depositTextController.text.isEmpty) return;

    await writeContract(_addDepositAmount, [
      BigInt.from(int.parse(depositTextController.text)),
    ]);
    checkDeposit();
  }

  Future<void> withdrawBalance() async {
    await writeContract(_withdrawBalance, []);
    checkBalance();
    checkDeposit();
  }
}
