class AppUser {
  String? authId;
  String? fullName;
  String? email;
  String? phoneNumber;
  bool? isVerified;

  AppUser(
      {this.authId,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.isVerified});

  AppUser.fromFirestore(Map<String, dynamic>? docData)
      : this(
            authId: docData?['authId'],
            fullName: docData?['fullName'],
            email: docData?['email'],
            phoneNumber: docData?['phoneNumber'],
            isVerified: docData?['isVerified']);

  Map<String, dynamic> toFirestore() {
    return {
      "authId": authId,
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "isVerified": isVerified
    };
  }
}
