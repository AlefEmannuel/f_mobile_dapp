import 'package:f_vote/forum_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComentPage extends StatefulWidget {
  final ForumController controller;

  const ComentPage({Key? key, required this.controller}) : super(key: key);

  @override
  _ComentPageState createState() => _ComentPageState();
}

class _ComentPageState extends State<ComentPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Fórum')),
      body: Center(
        child: Container(
          width: width * .9,
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        child: Text('AE'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Obx(
                        () => Flexible(
                          child: Text(
                            widget
                                .controller
                                .topicList[
                                    widget.controller.selectedIndex.value]
                                .comment,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Interações",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                              itemCount: widget.controller.comentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "#${index + 1}: ${widget.controller.comentList[index].text}"),
                                  ],
                                );
                              }),
                        ),
                      ),
                    ],
                  )),
              ElevatedButton(
                  onPressed: () {
                    widget.controller.getAllComents();
                  },
                  child: Text('Atualizar'))
            ],
          ),
        ),
      ),
    );
  }
}
