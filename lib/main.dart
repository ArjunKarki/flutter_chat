import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/authScreen.dart';
import 'package:flutter_chat/screens/chatScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // var token = await messaging.getToken();
    // print("Token$token");

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void _submitAuthForm(email, userName, password, isLogin, proPic, ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final imgRef = FirebaseStorage.instance
            .ref()
            .child("userImage")
            .child(userCredential.user.uid + "jpg");

        await imgRef.putFile(proPic);
        final picUrl = await imgRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection("user")
            .doc(userCredential.user.uid)
            .set({
          "email": userCredential.user.email,
          "name": userName,
          "proPic": picUrl
        });
      }
    } on FirebaseAuthException catch (e) {
      String msg = "";
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      } else {
        msg = e.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("error=>$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen(_submitAuthForm, isLoading);
        },
      ),
    );
  }
}
