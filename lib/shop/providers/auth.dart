import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _email;
  String _phonenumber;
  String _userId;
  var _timeLastLogin = DateTime.parse("2021-05-25 10:00:00Z");
  bool _isAnonym = true;
  User LoggedUser;

  bool get isLoggedIn {
    return _token != null && _userId != null;
  }

  bool get isAuth {
    return _token != null;
  }

  String get phoneNumber {
    if (isAdmin) {
      return 'Admin';
    } else {
      return _phonenumber;
    }
  }

  bool get isAdmin {
    return _email == 'admin@admin.de';
  }

  bool get isAnonym {
    return isAdmin ? false : phoneNumber == null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      signInAnonymously();
      _isAnonym = true;
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    if (extractedUserData['token'] != null) {
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _email = extractedUserData['email'];
      _phonenumber = extractedUserData['phonenumber'];
      _timeLastLogin = DateTime.parse(extractedUserData['timeLastLogin']);
      var difference = _timeLastLogin.difference(DateTime.now());
      if (difference.inMinutes <= -30) {
        if (_phonenumber != null) {
          if (_phonenumber == "Admin") {
            signInWithEmailAndPassword("admin@admin.de", "Fd-12345");
          } else {
            verifyPhoneNumber(_phonenumber);
          }
        } else {
          signInAnonymously();
        }
        logout();
      }
      notifyListeners();
    } else {
      return false;
    }
    return true;
  }

  ////====================================================================================================
  ///NEW
  ///=====================================================================================================
  //Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;

  void logout() async {
    try {
      _token = null;
      _userId = null;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': null,
        'userId': null,
        'phonenumber': null,
      });
      prefs.setString('userData', userData);
      notifyListeners();
      await _auth.signOut();
      print("8Successfully signed out");
    } catch (e) {
      print("9Failed to sign out: " + e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _timeLastLogin = DateTime.now();
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      extractUserData(user);
      //Success = true
    } catch (e) {
      print('Failed to sign in with Email & Password');
      _auth.signOut();
      //Success = false
    }
  }

  Future<void> extractUserData(User user) async {
    if (user != null) {
      _userId = user.uid;
      _email = user.email;
      _phonenumber = user.phoneNumber;
      await user.getIdToken().then((token) => _token = token);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'email': _email,
        'phonenumber': _phonenumber,
        'timeLastLogin': _timeLastLogin.toString(),
      });
      prefs.setString('userData', userData);
    }
    _isAnonym = user.isAnonymous;
    LoggedUser = user;
  }

  Future<void> verifyPhoneNumber(String phone) async {
    _timeLastLogin = DateTime.now();
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      final User user =
          (await _auth.signInWithCredential(phoneAuthCredential)).user;
      extractUserData(user);
      //'Phone number automatically verified and user signed in: $phoneAuthCredential'),
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      //'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      logout();
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      //'Please check your phone for the verification code.
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      //'Failed to Verify Phone Number: $e'),
      logout();
    }
  }

  Future<void> signInAnonymously() async {
    try {
      _timeLastLogin = DateTime.now();
      final User user = (await _auth.signInAnonymously()).user;
      //Success = true
      extractUserData(user);
    } catch (e) {
      //Success = false
    }
  }
}
