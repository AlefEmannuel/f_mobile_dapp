// Container(
//                 padding: EdgeInsets.only(top: 30),
//                 height: height * .25,
//                 color: Colors.blue,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       children: const [
//                         CircleAvatar(
//                           child: Text('A'),
//                         ),
//                         Text(
//                           'Total votes: 0',
//                           style: TextStyle(color: Colors.white),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       width: 50,
//                     ),
//                     Column(
//                       children: const [
//                         CircleAvatar(
//                           child: Text('B'),
//                         ),
//                         Text(
//                           'Total votes: 0',
//                           style: TextStyle(color: Colors.white),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       controller.vote(true);
//                     },
//                     child: Text('Vote alpha'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       controller.vote(false);
//                     },
//                     child: Text('Vote beta'),
//                   )
//                 ],
//               ),
//               Obx(() => Text('${controller.isLoading}')),