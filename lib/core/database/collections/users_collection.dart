import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/core/database/models/app_user.dart';

class UsersCollection {
  CollectionReference<AppUser> getUsersCollection() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return db.collection("Users").withConverter(
      fromFirestore: (snapshot, options) {
        return AppUser.fromFirestore(snapshot.data());
      },
      toFirestore: (obj, options) {
        return obj.toFirestore();
      },
    );
  }

  Future<void> addUser(AppUser user) {
    return getUsersCollection().doc(user.authId).set(user);
  }

  Future<AppUser?> readUser(String userID) async {
    DocumentSnapshot<AppUser> snapshot =
        await getUsersCollection().doc(userID).get();
    return snapshot.data();
  }

  Future<void> deleteUser(String userID) {
    return getUsersCollection().doc(userID).delete();
  }

  Future<void> updateVerificationStatus(String userID, bool newStatus) {
    return getUsersCollection().doc(userID).update({"isVerified": newStatus});
  }
}
