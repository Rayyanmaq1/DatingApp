import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'Pages/Imissed.dart';
import 'Pages/TheyMissed.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/HistoryController.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int seleted = 0;
  List<Widget> pageList = List<Widget>();
  PageController controller = PageController();
  // final historyCtr = Get.put(HistoryController());
  @override
  void initState() {
    pageList.add(TheyMissed());

    pageList.add(Imissed());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: greyColor,
        appBar: AppBar(
          elevation: 0,
          title: Text('History'),
          backgroundColor: greyColor,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    seleted = 0;
                  }),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: SizeConfig.heightMultiplier * 4,
                    child: Center(
                      child: Text(
                        'They missed',
                        style: TextStyle(
                            color: seleted == 0 ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: seleted == 0 ? purpleColor : Colors.grey[850],
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    seleted = 1;
                  }),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: SizeConfig.heightMultiplier * 4,
                    child: Center(
                      child: Text(
                        'I missed',
                        style: TextStyle(
                            color: seleted == 1 ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: seleted == 1 ? purpleColor : Colors.grey[850],
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
            pageList[seleted],
          ],
        ),
      ),
    );
  }
}
