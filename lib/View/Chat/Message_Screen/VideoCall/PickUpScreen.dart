import 'package:flutter/material.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call.dart';
import 'package:livu/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AudioCall.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  // final CallMethods callMethods = CallMethods();

  PickupScreen({
    @required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(call.callerPic),
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Container(
          color: greyColor.withOpacity(0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Incoming...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              SizedBox(height: 15),
              Text(
                call.callerName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PhysicalModel(
                    elevation: 8,
                    shadowColor: Colors.red,
                    color: Colors.red,
                    shape: BoxShape.circle,
                    child: IconButton(
                      icon: Icon(Icons.call_end),
                      color: Colors.white,
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('PrivateCall')
                            .doc(call.callerId)
                            .delete();
                      },
                    ),
                  ),
                  SizedBox(width: 25),
                  PhysicalModel(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    child: IconButton(
                        icon: Icon(Icons.call),
                        color: Colors.white,
                        onPressed: () async => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => call.videoCall
                                    ? CallPage(
                                        channelName: call.channelId,
                                        documentId: call.callerId,
                                      )
                                    : AudioCallPage(
                                        call: call,
                                      ),
                              ),
                            )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
