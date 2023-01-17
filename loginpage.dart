import 'package:chatbox/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'exitpopup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
// creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );
    return Scaffold(
      appBar: AppBar(

          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor:Color(0xff113162),),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor:Color(0xff113162) ,
          title: Text("CHATTER"),centerTitle: true,),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: WillPopScope(
            onWillPop: () => showExitPopup(context),
            child: Builder(builder: (context) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please Login Through Your Account-",
                          style: TextStyle(
                            color: Color(
                              0xff113162,
                            ),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      InkWell(child: Image.asset('assets/images/google.png',),onTap: () {
                        signup();
                      },),


                    ]),
              );
            }),
          ),
        ),
      ),
    );
  }

  signup() async {
    debugPrint("SIGNUP FUNCTION IS CALLED--------------------");
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(

          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      print("USER INFORMATION IS AS FOLLOWS--------------------");

      if (user!=null) {
        print(result.user?.displayName);


        // FirebaseFirestore.instance
        //     .collection('data').
        //     add({'name': '${auth.currentUser!.displayName}',"image":"${auth.currentUser!.photoURL}","email":"${auth.currentUser!.email}"})
        //     .then((value) => print("User Added"))
        //     .catchError((error) => print("Failed to add user: $error"));

        FirebaseFirestore.instance.collection('data').
        doc('${auth.currentUser!.email}')
            .set({'name': '${auth.currentUser!.displayName}',
          "image":"${auth.currentUser!.photoURL}",
          "email":"${auth.currentUser!.email}",
          "senderid":"${auth.currentUser?.email}",
          "receiverid":"null",
          "message":null,
          "messagetype":"Text",
          "time":"${DateTime.now().millisecondsSinceEpoch}",
          "isread":"null",
            });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        Fluttertoast.showToast(
          msg: "${auth.currentUser?.displayName} is successfully login", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1, // duration
        );
      }else  if (user==null) {
        print(result.user?.displayName);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        Fluttertoast.showToast(
          msg: "Something Went Wrong!", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1, // duration
        );
      }
    }
  }
}
