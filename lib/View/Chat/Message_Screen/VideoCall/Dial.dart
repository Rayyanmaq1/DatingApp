import 'package:livu/Model/VideoCallModel.dart';
import 'package:flutter/material.dart';
import 'package:livu/Services/PrivateVideoCall.dart';
import 'call.dart';
import 'AudioCall.dart';

class CallUtils {
  static final PrivateCallService callMethods = PrivateCallService();

  static var channelId = UniqueKey().toString();

  static dial(
      {UserCallModel from, UserCallModel to, context, bool videoCall}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.imageUrl,
      receiverId: to.uid,
      videoCall: videoCall,
      receiverName: to.name,
      receiverPic: to.imageUrl,
      hasDialled: false,
      channelId: channelId,
    );
    Map<String, dynamic> data = Call().toMap(call);

    await callMethods.setData(data);
    print(call.videoCall);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => call.videoCall
            ? CallPage(
                documentId: from.uid,
                channelName: channelId,
              )
            : AudioCallPage(
                call: call,
              ),
      ),
    );
  }
}
