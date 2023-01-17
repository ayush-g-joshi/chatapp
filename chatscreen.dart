import 'package:chatbox/userprofileinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Home page screen


import 'package:chatbox/viewprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chatbox/exitpopup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'chatscreen.dart';
import 'loginpage.dart';
class ChatScreen extends StatefulWidget {
  var name;
  var email;
  var image;
  var receiverid;


ChatScreen({Key? key,this.name,this.email,this.image,this.receiverid}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var sendmsg = [];

  var receivemsg = [];
  TextEditingController message = TextEditingController();

  // creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('data');
  var responsemsg;
  var oldmessage;
  @override
  void initState() {

    getoldMessage();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xff113162),),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Color(0xff113162),
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      UserProfileInfo(email: widget.email,
                        image: widget.image,
                        name: widget.name,)));
            },
            child: Row(
              children: [
                Center(
                  child: ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: FittedBox(
                        child:
                        Image.network('${widget.image}'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Text("${widget.name}"),
              ],
            ),
          ),
          centerTitle: true),
      body:Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
         SingleChildScrollView(
           child: Column(
            children: [
              for ( var i in sendmsg )
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                       color: Color(0xff113162),),

                    child: Text(i.toString(),style: TextStyle(color: Colors.white),)),
              ),
            ],
        ),
         ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: "Message",
              prefixIcon: Icon(Icons.message),
              labelStyle: TextStyle(fontSize: 20),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(onPressed: () {

               setState(() {
                 sendmsg.add(message.text.trim().toString());
                 sendMessage();
                 message.clear();
               });
              }, icon: Icon(Icons.send),)
          ),
          controller: message,

        ),
      ],)
    );
  }
getoldMessage()async{
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  print(allData);

responsemsg=allData;
var particularmsg;
  particularmsg=responsemsg[0]["message"] ;
print(particularmsg.toString());



  // receivemsg.add(particularmsg);



}
  sendMessage() async {
    setState(() {

      print('SENDED MESSAGE LIST IS---------------$sendmsg');
      FirebaseFirestore.instance.collection('data').
      doc('${widget.receiverid}')
          .set({'name': '${auth.currentUser!.displayName}',
        "image": "${auth.currentUser!.photoURL}",
        "email": "${auth.currentUser!.email}",
        "senderid": "${auth.currentUser?.email}",
        "receiverid": "${widget.receiverid}",
        "message": "${sendmsg}",
        "messagetype": "Text",
        "time": "${DateTime
            .now()
            .millisecondsSinceEpoch}",
        "isread": "null",
      });
      FirebaseFirestore.instance.collection('data').
      doc('${auth.currentUser?.email}')
          .set({'name': '${auth.currentUser!.displayName}',
        "image": "${auth.currentUser!.photoURL}",
        "email": "${auth.currentUser!.email}",
        "senderid": "${auth.currentUser?.email}",
        "receiverid": "${widget.receiverid}",
        "message": "${sendmsg}",
        "messagetype": "Text",
        "time": "${DateTime
            .now()
            .millisecondsSinceEpoch}",
        "isread": "null",
      });
    });
    //  FirebaseFirestore.instance.collection('data').
    // add({
    //     "name": '${auth.currentUser!.displayName}',
    //      "image":"${auth.currentUser!.photoURL}",
    //      "email":"${auth.currentUser!.email}",
    //    "senderid":"${auth.currentUser?.uid}",
    //    "receiverid":"${widget.receiverid}",
    //    "message":"${message.text.trim().toString()}",
    //    "messagetype":"Text",
    //    "time":"${DateTime.now().millisecondsSinceEpoch}",
    //    "isread":"null",
    //  });


  }
}
//
// StreamBuilder(
// stream: FirebaseFirestore.instance.collection("data").snapshots(),
// builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// if (!snapshot.hasData) {
// return Center(
// child: CircularProgressIndicator(),
// );
// }
//
// return SingleChildScrollView(
// child: Column(
// children: [
// Container(
// height: 750,
// color: Colors.yellow,
// child: ListView(
// children: snapshot.data!.docs.map((document) {
// return Container(
// child: Column(
// children: [
// // sendmsg == null ? Text("") :
//
// for ( var i in sendmsg ) Text(i.toString()),
// // Container(
// //     color: Colors.deepOrange,
// //     child: Center(child: Text(
// //       sendmsg.toString()))),
// // Center(child: Text(document['time'])),
// // Center(child: Text(document['isread'])),
//
// ],
// ),
// );
// }).toList(),
// ),
// ),
// TextFormField(
// keyboardType: TextInputType.emailAddress,
// decoration: InputDecoration(
// labelText: "Message",
// prefixIcon: Icon(Icons.message),
// labelStyle: TextStyle(fontSize: 20),
// filled: true,
// fillColor: Colors.white,
// suffixIcon: IconButton(onPressed: () {
// sendMessage();
// message.clear();
// }, icon: Icon(Icons.send),)
// ),
// controller: message,
//
// ),
// ],
// ),
// );
// },
// ),