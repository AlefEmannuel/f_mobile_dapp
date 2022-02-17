import 'dart:async';
import 'dart:typed_data';

import 'package:f_vote/coments_model.dart';
import 'package:f_vote/topic_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ForumController extends GetxController {
  ForumController() {
    initState();
  }

  late Client httpClient;

  late Web3Client ethClient;

//Ethereum address
  final String myAddress = "0x445037CaadF42b01C1B85BD41611Bf363a70613b";

//url from Infura
  final String blockchainUrl =
      "https://ropsten.infura.io/v3/407f691e73a848249205828cc673158e";

  List<TopicModel> topicList = <TopicModel>[].obs;

  List<ComentModel> comentList = <ComentModel>[].obs;

  RxBool isLoading = false.obs;

  RxString newTopicText = ''.obs;
  RxString newCommentText = ''.obs;

  RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      await getAllTopics();
    });
  }

  Future<DeployedContract> getContract() async {
//obtain our smart contract using rootbundle to access our json file
    String abiFile = await rootBundle.loadString("assets/contract2.json");

    String contractAddress = "0x580D42EBd99789F923D44a5f445FbaA91f71Fe12";

    final contract = DeployedContract(ContractAbi.fromJson(abiFile, "Topic"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> callFunction(String name) async {
    final contract = await getContract();
    final function = contract.function(name);
    final result = await ethClient
        .call(contract: contract, function: function, params: []);
    return result;
  }

  Future<List<dynamic>> getData(String name, List<dynamic> params) async {
    final contract = await getContract();
    final function = contract.function(name);
    final result = await ethClient.call(
        contract: contract, function: function, params: params);
    return result;
  }

  Future<void> getAllTopics() async {
    List<dynamic> getAllTopics = await callFunction("getAllTopics");
    String data = getAllTopics.toString();
    List<String> result = data.replaceAll(RegExp(r'\['), '').split(',');
    topicList.clear();
    topicList.addAll(getTopics(result));
  }

  List<TopicModel> getTopics(List<String> data) {
    List<TopicModel> topics = [];
    for (var i = 0; i < data.length; i = i + 6) {
      topics.add(
          TopicModel(id: data[i], address: data[i + 1], comment: data[i + 3]));
    }

    return topics;
  }

  Future<void> getAllComents() async {
    List<dynamic> getAllComents = await getData(
        "getAllComments", [BigInt.parse(topicList[selectedIndex.value].id)]);
    String data = getAllComents.toString();
    List<String> result = data.replaceAll('[', '').split(',');
    String result2 = result.toString().replaceAll(RegExp(r'\]'), '');
    List<String> commentList = result2.split(',');
    print(commentList);
    comentList.clear();
    comentList.addAll(getComents(commentList));
  }

  List<ComentModel> getComents(List<String> data) {
    List<ComentModel> list = [];
    for (var i = 0; i < data.length; i = i + 4) {
      if (data.length > 3) {
        list.add(
            ComentModel(id: data[i], address: data[i + 1], text: data[i + 3]));
      }
    }

    return list;
  }

  Future<void> createTopic() async {
    isLoading = true.obs;
    Credentials key = EthPrivateKey.fromHex(
        "a81e3c93f759f27d157d79fbbd076a26b765f3e360ddc683ae2c305b52e6ea4f");
    Future.delayed(const Duration(seconds: 10), () {
      isLoading = false.obs;
    });
    //obtain our contract from abi in json file
    final contract = await getContract();

    // extract function from json file
    final function = contract.function("createTopic");

    String transactionHex = "";

    //send transaction using the our private key, function and contract
    await ethClient
        .sendTransaction(
            key,
            Transaction.callContract(
                contract: contract,
                function: function,
                value: EtherAmount.inWei(BigInt.from(10000000000000000)),
                parameters: [newTopicText.value.replaceAll(",", ";")]),
            chainId: 3)
        .then((value) {
      transactionHex = value;
    });
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      TransactionInformation trans =
          await ethClient.getTransactionByHash(transactionHex);

      if (trans.blockHash != null) {
        print("Transaction: ${trans.blockHash.toString()}");
        isLoading = false.obs;
        isLoading.value = false;
        await getAllTopics();
        timer.cancel();
      }
    });
  }

  Future<void> donate(String address) async {
    Credentials key = EthPrivateKey.fromHex(
        "a81e3c93f759f27d157d79fbbd076a26b765f3e360ddc683ae2c305b52e6ea4f");

    //obtain our contract from abi in json file
    final contract = await getContract();

    // extract function from json file
    final function = contract.function("donate");

    await ethClient.sendTransaction(
        key,
        Transaction.callContract(
            contract: contract,
            function: function,
            value: EtherAmount.fromUnitAndValue(
                EtherUnit.wei, newCommentText.value),
            parameters: [
              EthereumAddress.fromHex(address.replaceAll(" ", "")),
            ]),
        chainId: 3);
    newTopicText.value = '';
    print("doou");
  }

  Future<void> createComment() async {
    isLoading = true.obs;
    Credentials key = EthPrivateKey.fromHex(
        "a81e3c93f759f27d157d79fbbd076a26b765f3e360ddc683ae2c305b52e6ea4f");

    //obtain our contract from abi in json file
    final contract = await getContract();

    // extract function from json file
    final function = contract.function("commentTopic");
    print(BigInt.parse(topicList[selectedIndex.value].id));
    //send transaction using the our private key, function and contract
    await ethClient.sendTransaction(
        key,
        Transaction.callContract(
            contract: contract,
            function: function,
            value: EtherAmount.inWei(BigInt.from(1000000000000000)),
            parameters: [
              BigInt.parse(topicList[selectedIndex.value].id),
              newCommentText.value.replaceAll(",", ";")
            ]),
        chainId: 3);
    newTopicText.value = '';
    Future.delayed(const Duration(seconds: 5), () {
      getAllTopics();
      isLoading = false.obs;
    });
  }
}
