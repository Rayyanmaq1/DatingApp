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
    size = snap.docs.length;
    console.log("Length",size);
    if(size >=2){
        console.log("FOUNT TWO");

    }
});
