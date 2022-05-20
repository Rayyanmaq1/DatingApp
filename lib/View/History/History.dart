import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'Pages/Imissed.dart';
import 'Pages/TheyMissed.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:easy_localization/easy_localization.dart';

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
        backgroundColor: AppColors.greyColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'History',
            style: TextStyle(color: Colors.white),
          ).tr(),
          backgroundColor: AppColors.greyColor,
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
                        'They_Missed_History',
                        style: TextStyle(
                            color: seleted == 0 ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                    decoration: BoxDecoration(
                        color: seleted == 0
                            ? AppColors.purpleColor
                            : Colors.grey[850],
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
                        'I_Missed',
                        style: TextStyle(
                            color: seleted == 1 ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                    decoration: BoxDecoration(
                        color: seleted == 1
                            ? AppColors.purpleColor
                            : Colors.grey[850],
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
