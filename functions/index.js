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
   const newValue =await snap.data();

  const genderSearch =await newValue.SelectedGender;
    console.log('selected',genderSearch);
    if(genderSearch == 1){
        await fb.collection('SearchVideoCall').where('SelectedGender', '==' ,1).orderBy('timeStamp','desc').get().then(snapshot => {
        if(snapshot.docs.length>2){
            snapshot.docs.map((e)=>{
                if(e.Uid != newValue.Uid){
                    let uniqueID = (Math.random() + 1).toString(36).substring(7);
                     fb.collection('${ConnectedVideocall}').add({ 

                      }).then(ref => {
                    console.log('Added document with ID: ', ref.id)
                    });


                    break;
                }
            });
        }
        
    });
    }
   else if(genderSearch == 2){
        await fb.collection('SearchVideoCall').where('SelectedGender', '==' ,2).orderBy('timeStamp','desc').get().then(snapshot => {
        size = snapshot.docs.length;
        console.log("MALE SIZE" , size);
    });
   }
   else if(genderSearch == 3){
        await fb.collection('SearchVideoCall').where('SelectedGender', '==' ,3).orderBy('timeStamp','desc').get().then(snapshot => {
        size = snapshot.docs.length;
        console.log("FEMALE SIZE" , size);
    });
 }
   
});
