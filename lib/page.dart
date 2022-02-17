import 'package:f_vote/coment_page.dart';
import 'package:f_vote/controller.dart';
import 'package:f_vote/forum_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = Get.put(HomeController());
  ForumController forumController = Get.put(ForumController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fórum'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 80),
          width: width * .9,
          child: Column(
            children: [
              TextField(
                controller: _textController,
                onChanged: (value) {
                  forumController.newTopicText.value = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  forumController.createTopic();
                  _textController.clear();
                },
                child: const Text('Cadastrar tópico'),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tópicos:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          forumController.getAllTopics();
                        },
                        icon: const Icon(Icons.refresh_outlined))
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                      itemCount: forumController.topicList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "#${index + 1}: ${forumController.topicList[index].comment}"),
                            IconButton(
                                onPressed: () {
                                  forumController.selectedIndex.value = index;
                                  forumController.getAllComents();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ComentPage(
                                              controller: forumController,
                                            )),
                                  );
                                },
                                icon:
                                    const Icon(Icons.arrow_right_alt_outlined))
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
