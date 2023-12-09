// 398. Create an auth controller class.
//import 'dart:html';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/models/signup_body_model.dart';
import 'package:food_app_firebase/pages/home/main_food_page.dart';
import 'package:get/get.dart';
import '../data/repository/auth_repo.dart';
import '../pages/account/account_page.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/home/home_page.dart';

class AuthController extends GetxController implements GetxService {
  //final AuthRepo authRepo;
  AuthController(
    //required this.authRepo
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  registration(SignUpBody signUpBody) {
    _isLoading = true;
  }

  // 399. To set the firebase auth:
  // I. Add multidex dependencies to app/build.gradle: implementation "com.android.support:multidex:1.0.3"
  // II. Activate phone, email and google signin methods.
  // III. On terminal run: flutter pub add firebase_auth

  // 400. Create a Rx User and instance to get access to Firebase Auth. Import firebase_auth first.
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  // 417. auth current user object make it public using a getter.
  Rx<User?> get currentFirebaseAuthUser => _user;
  User? get currentUser => _user.value;

  //bool userLoggodIn = (currentUser == null ? true : false);

  @override
  void onReady() {
    super.onReady();
    // 401. Get the current firebase user.
    _user = Rx<User?>(auth.currentUser);
    // 402. Our user would be notified.
    _user.bindStream(auth.userChanges());
    // 404. Use ever() function to take a listener and a callback function to interact.
    // Whenever the user login/logout, the user will be notified and the ever() function runs.
    ever(_user, _initialScreen);
  }

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user.value = user;
    });
  }

  // 403. Set the initial screen to check whether the use has logged in or not.
  _initialScreen(User? user) async {
    if (user ==  null) {
      print("login page");
      Get.offAll(() => SignInPage());
    } else {
      print("logged into main food page");

      // 409. Get user account info from Firestore.
      String uid = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;

        String name = userData['name'];
        String phone = userData['phone'];
        String email = user.email!;

        Get.offAll(() => HomePage());
      } else {
        print("User data does not exist.");
      }
    }
  }

  // 405. Implement register function for user to sign up using email and password.
  Future<void> register(String email, password, name, phone) async {
    try {
      // 409. Create user in Firebase Authentication.
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // 410. Get the user's UID and hash the password.
      User? user = userCredential.user;
      String uid = user!.uid;
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // 527. Get the number of records of users stored in the Firebase to get the user_id.
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      int userLength = querySnapshot.size;

      // 413. Save user info in Firestore.
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name, 'phone': phone, 'password': hashedPassword, 'email': email, 'orderCount': 0, 'user_id': userLength+1
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("About User", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Center(child: Text("Account creation failed",
              style: TextStyle(
                  color: Colors.white
              )
          )),
          messageText: Center(child: Text("The password provided is too weak",
              style: TextStyle(
                  color: Colors.white
              )
          )),
        );
      } else if (e.code == 'email-already-in-use') {
        // Proved ok using Android real device. But failed in using ios simulator.
        Get.snackbar("About User", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Center(child: Text("Account creation failed",
              style: TextStyle(
                  color: Colors.white
              )
          )),
          messageText: Center(child: Text("The email address is already in use by another account",
              style: TextStyle(
                  color: Colors.white
              )
          )),
        );
      } else {
        print(e.toString());
        Get.snackbar("About User 1", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Center(child: Text("Account creation failed One",
              style: TextStyle(
                  color: Colors.white
              )
          )),
          messageText: Center(child: Text(e.toString(),
              style: TextStyle(
                  color: Colors.white
              )
          )),
        );
      }
    } catch (e) {
        Get.snackbar("About User 2", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Center(child: Text("Account creation failed Two",
            style: TextStyle(
              color: Colors.white
            )
          )),
          messageText: Center(child: Text(e.toString(),
            style: TextStyle(
              color: Colors.white
            )
          )),
        );
    }
  }

  // 406. Implement login function for user to load the current user information. Use signin method here.
  Future<void> login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("About Login", "Login message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Center(child: Text("Login Failed",
            style: TextStyle(
                color: Colors.white
            )
        )),
        messageText: Center(child: Text(e.toString(),
            style: TextStyle(
                color: Colors.white
            )
        )),
      );
    }
  }

  // 408. Implement logout function using signOut function.
  void logout() async {
    await auth.signOut();
  }
}