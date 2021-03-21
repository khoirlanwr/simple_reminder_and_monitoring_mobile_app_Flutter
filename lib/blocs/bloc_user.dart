import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocUser extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _disposed = false;

  String _uid = "";

  int numberUser = 11;

  // getter
  bool get isLoggedIn => _isLoggedIn;

  String get uid => _uid;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  // sign in firebase
  Future<String> signIn(String email, String password) async {
    print('signIn called');
    String returnValue;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _isLoggedIn = true;
      numberUser = 12;

      _uid = userCredential.user.email;
      returnValue = "login-success";

      notifyListeners();
      saveLoginRecordToSF(email, password);

      print('loginsuccess');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      _isLoggedIn = false;
      returnValue = e.code;
      print('Login failure');
    }

    return returnValue;
  }

  // sign up firebase
  Future<String> createUser(String email, String password) async {
    String returnValue;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      returnValue = "register-success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      returnValue = e.message;
    } catch (e) {
      print(e);
      returnValue = e.message;
    }

    notifyListeners();
    return returnValue;
  }

  // sign out firebase
  Future<void> signOut() async {
    print('signing out...');
    await FirebaseAuth.instance.signOut();
    notifyListeners();

    _isLoggedIn = false;
    numberUser = 11;
    _uid = "";

    removeLoginRecordFromSF();
  }

  void saveLoginRecordToSF(String emailKey, String passwordKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", emailKey);
    prefs.setString("password", passwordKey);
  }

  void removeLoginRecordFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("password");
  }

  Future<String> getLoginRecordFromSF() async {
    String returnValue = "empty";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String recordedEmail = prefs.getString("email");
    String recordedPassword = prefs.getString("password");

    print(recordedEmail);
    print(recordedPassword);

    if ((recordedEmail != null) && (recordedPassword != null)) {
      print(recordedEmail);
      print(recordedPassword);

      String result = await signIn(recordedEmail, recordedPassword);
      if (result == "login-success") {
        returnValue = "getLoginRecordFromSF-success";
      } else {
        returnValue = "getLoginRecordFromSF-failure";
      }
    }

    return returnValue;
  }
}
