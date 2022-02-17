import 'dart:math';

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: Center(
        child: Container(
          width: width * .9,
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Container(
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
                              .topicList[widget.controller.selectedIndex.value]
                              .comment,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Interações",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {
                                widget.controller.getAllComents();
                              },
                              icon: const Icon(Icons.refresh_outlined)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.controller.comentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          bottom: 10, left: 10),
                                      title: Text(
                                        widget
                                            .controller.comentList[index].text,
                                        textAlign: TextAlign.start,
                                      ),
                                      leading: const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            "https://picsum.photos/300/300"),
                                      ),
                                      subtitle: Text(widget.controller
                                          .comentList[index].address),
                                      trailing: IconButton(
                                          onPressed: () {
                                            widget.controller.selectedIndex
                                                .value = index;
                                            widget.controller.getAllComents();
                                          },
                                          icon: const Icon(
                                              Icons.arrow_right_alt_outlined))),
                                );
                              }),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
