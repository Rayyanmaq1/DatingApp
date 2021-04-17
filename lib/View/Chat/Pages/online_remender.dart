import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:livu/theme.dart';

class OnlineRemender extends StatefulWidget {
  @override
  _OnlineRemenderState createState() => _OnlineRemenderState();
}

class _OnlineRemenderState extends State<OnlineRemender> {
  bool varIsInstructionView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191919),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: greyColor,
        title: Text(
          "Online Remender",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Friend online notification: ",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "1/10 ",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   child: ListView.separated(
            //     shrinkWrap: true,
            //     physics: BouncingScrollPhysics(),
            //     separatorBuilder: (context, index) {
            //       return Divider(
            //         color: Colors.grey[850],
            //       );
            //     },
            //     itemBuilder: (context, index) {
            //       return chatContainer(index);
            //     },
            //     itemCount: chats.length,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // chatContainer(index) {
  //   return ListTile(
  //     leading: CircleAvatar(
  //       backgroundImage: NetworkImage(
  //         chats[index].sender.imageUrl,
  //       ),
  //       radius: 30,
  //     ),
  //     title: Text(
  //       chats[index].sender.name,
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     subtitle: Row(
  //       children: [
  //         Flag(chats[index].sender.flag,
  //             height: 10, width: 15, fit: BoxFit.fill),
  //         SizedBox(
  //           width: 5,
  //         ),
  //         Text(
  //           chats[index].sender.country,
  //           style: TextStyle(color: Colors.grey[400]),
  //         ),
  //       ],
  //     ),
  //     trailing: Switch.adaptive(
  //       value: varIsInstructionView,
  //       onChanged: (newValue) => setState(() {
  //         varIsInstructionView = newValue;
  //       }),
  //       activeColor: Colors.amber,
  //     ),
  //   );
  // }
}
