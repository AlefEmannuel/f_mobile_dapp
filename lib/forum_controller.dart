import 'package:f_vote/model.dart';
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

  RxBool isLoading = false.obs;

  RxString newTopicText = ''.obs;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    getAllTopics();
  }

  Future<DeployedContract> getContract() async {
//obtain our smart contract using rootbundle to access our json file
    String abiFile = await rootBundle.loadString("assets/contract2.json");

    String contractAddress = "0xB7bab6e107130f70e7195323a0209Be9C308674C";

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

  Future<void> createTopic() async {
    //showSnackBar(label: "Recording vote");
    //obtain private key for write operation
    isLoading = true.obs;
    Credentials key = EthPrivateKey.fromHex(
        "a81e3c93f759f27d157d79fbbd076a26b765f3e360ddc683ae2c305b52e6ea4f");

    //obtain our contract from abi in json file
    final contract = await getContract();

    // extract function from json file
    final function = contract.function("createTopic");

    //send transaction using the our private key, function and contract
    await ethClient.sendTransaction(
        key,
        Transaction.callContract(
            contract: contract,
            function: function,
            parameters: [newTopicText.value]),
        chainId: 3);
    newTopicText.value = '';
    Future.delayed(const Duration(seconds: 20), () {
      getAllTopics();
      isLoading = false.obs;
    });
  }
}
