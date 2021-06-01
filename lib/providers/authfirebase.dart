import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthFirebaseee with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> StartTest() async {
    await _signInWithEmailAndPassword('admin@admin.de', 'Fd-12345');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  // Example code for registration E-Mail.
  Future<void> _registerEmailAndPassword(String email, String password) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      print('Success = true');
    } else {
      print('Success = false');
    }
  }

  // Example code of how to sign in with email and password.
  Future<void> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      print('${user.email} signed in');
      print(user.emailVerified);
      print(user.getIdToken());
      print(user.uid);
      //Success = true
    } catch (e) {
      print('Failed to sign in with Email & Password');
      //Success = false
    }
  }

  // Example code of how to sign in with email and link.
  Future<void> _signInWithEmailAndLink(String email, context) async {
    try {
      await _auth.sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
              url:
                  'https://react-native-firebase-testing.firebaseapp.com/emailSignin',
              handleCodeInApp: true,
              iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
              androidPackageName: 'io.flutter.plugins.firebaseauthexample'));

      Scaffold.of(context).showSnackBar(
        SnackBar(
          //Success = true
          content: Text('An email has been sent to $email'),
        ),
      );
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          //Success = false
          content: Text('Sending email failed'),
        ),
      );
    }
  }

  // Example code of how to sign in anonymously.
  Future<void> _signInAnonymously(context) async {
    try {
      final User user = (await _auth.signInAnonymously()).user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          //Success = true
          content: Text('Signed in Anonymously as user ${user.uid}'),
        ),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          //Success = false
          content: Text('Failed to sign in Anonymously'),
        ),
      );
    }
  }

  // Example code of how to verify phone number
  Future<void> _verifyPhoneNumber(String phone) async {
    String _verificationId;

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);

      //'Phone number automatically verified and user signed in: $phoneAuthCredential'),
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      //'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
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
    }
  }

  // Example code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber(String veriId, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: veriId,
        smsCode: smsCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      //'Successfully signed in UID: ${user.uid}',
    } catch (e) {
      print(e);
      //'Failed to sign in
    }
  }
}
