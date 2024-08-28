import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/core/database/collections/users_collection.dart';
import 'package:todo_app/core/database/models/app_user.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  UsersCollection usersCollection = UsersCollection();
  AppUser? appUser;
  User? firebaseAuthUser;
  bool? isEmailVerified;

  FirebaseAuthProvider() {
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    autoReadUser(firebaseAuthUser?.uid);
  }

  void autoReadUser(String? userID) async {
    if (isEmailVerified == true && firebaseAuthUser != null && userID != null) {
      appUser = await usersCollection.readUser(userID);
      notifyListeners();
    }
  }

  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser?.reload();
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseAuthUser != null;
  }

  // void logIn(User newUser) {
  //   firebaseAuthUser = newUser;
  //   notifyListeners();
  // }

  void logOut() {
    firebaseAuthUser = null;
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void deleteAccount(BuildContext context, String userId) async {
    await usersCollection.deleteUser(context, userId);
    await firebaseAuthUser?.delete();
    firebaseAuthUser = null;
    notifyListeners();
  }

  Future<void> sendEmailVerification(User user) {
    return user.sendEmailVerification();
  }

  Future<AppUser?> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String fullName,
      required String phoneNumber}) async {
    final UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      await sendEmailVerification(credential.user!);
      await reload();
      appUser = AppUser(
          authId: credential.user!.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          isVerified: credential.user!.emailVerified);
      await usersCollection.addUser(appUser!);
      return appUser;
    }
    return null;
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseAuth.instance.currentUser?.reload();
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      //logIn(credential.user!);
      await reload();
      if (isEmailVerified == true) {
        appUser = await usersCollection.readUser(credential.user!.uid);
      }
    }
    return appUser;
  }
}
