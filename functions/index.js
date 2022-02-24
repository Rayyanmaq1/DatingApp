const functions = require("firebase-functions");
const admin=require("firebase-admin");

admin.initializeApp();
var db=admin.database();
var fb=admin.firestore();
var fcm=admin.messaging();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.connectVideocall= functions.firestore.document('SearchVideoCall/{id}').onCreate(async(snap,context)=>{
   const newValue =snap.data();

  const genderSearch =await newValue.SelectedGender;
    console.log('selected',genderSearch);
        await fb.collection('SearchVideoCall').orderBy('timeStamp','desc').get().then(snapshot => {
            for (var i = 0; i < snapshot.docs.length; i++) {
                if(snapshot.docs[i].data().Uid != newValue.Uid && snapshot.docs[i].data().SelectedGender == genderSearch){
                    let uniqueID = (Math.random() + 1).toString(36).substring(7);
                    fb.collection('ConnectedVideoCall').add({
                        'ReciverUid': snapshot.docs[i].data().Uid,
                        'ReciverName': snapshot.docs[i].data().Name,
                        'ReciverImageUrl': snapshot.docs[i].data().ImageUrl,
                        'ReciverLikes': snapshot.docs[i].data().Likes,
                        'ReciverLocation': snapshot.docs[i].data().Location,
                        'ReciverAge': snapshot.docs[i].data().Age,
                        'SenderUid': newValue.Uid,
                        'SenderName': newValue.Name,
                        'SenderImageUrl': newValue.ImageUrl,
                        'SenderLikes': newValue.Likes,
                        'SenderLocation': newValue.Location,
                        'SenderAge': newValue.Age,
                        "ChannelID":uniqueID,
                        "timeStamp":new Date().getTime(),
                        "connectedUid":[newValue.Uid,snapshot.docs[i].data().Uid],
                    });
                    break;
                }
              }        
    });  
 });
