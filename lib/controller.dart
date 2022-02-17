import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class HomeController extends GetxController {
  HomeController() {
    //initState();
  }

  late Client httpClient;

  late Web3Client ethClient;

//Ethereum address
  final String myAddress = "0x445037CaadF42b01C1B85BD41611Bf363a70613b";

//url from Infura
  final String blockchainUrl =
      "https://ropsten.infura.io/v3/407f691e73a848249205828cc673158e";

//strore the value of alpha and beta
  var totalVotesA = 0;
  var totalVotesB = 0;

  RxBool isLoading = false.obs;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    getTotalVotes();
  }

  Future<DeployedContract> getContract() async {
//obtain our smart contract using rootbundle to access our json file
    String abiFile = await rootBundle.loadString("assets/contract.json");

    String contractAddress = "0xA386c0b8ADdDD692f35220F7C8f1750df6F39432";

    final contract = DeployedContract(ContractAbi.fromJson(abiFile, "Voting"),
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

  Future<void> getTotalVotes() async {
    List<dynamic> resultsA = await callFunction("getTotalVotesAlpha");
    List<dynamic> resultsB = await callFunction("getTotalVotesBeta");
    //totalVotesA = resultsA[0] as int;
    //totalVotesB = resultsB[0] as int;
    print('a votes: ${resultsA[0]}');
    print('b votes: ${resultsB[0]}');
  }

  Future<void> vote(bool voteAlpha) async {
    //showSnackBar(label: "Recording vote");
    //obtain private key for write operation
    isLoading = true.obs;
    Credentials key = EthPrivateKey.fromHex(
        "a81e3c93f759f27d157d79fbbd076a26b765f3e360ddc683ae2c305b52e6ea4f");

    //obtain our contract from abi in json file
    final contract = await getContract();

    // extract function from json file
    final function = contract.function(
      voteAlpha ? "voteAlpha" : "voteBeta",
    );

    //send transaction using the our private key, function and contract
    await ethClient.sendTransaction(
        key,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [],
        ),
        chainId: 3,
        fetchChainIdFromNetworkId: true);

    Future.delayed(const Duration(seconds: 20), () {
      getTotalVotes();
      isLoading = false.obs;
    });
  }
}
