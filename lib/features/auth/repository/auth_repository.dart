import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/auth/screens/otp_screen.dart';
import 'package:chatapp/features/auth/screens/user_information_screen.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/mobile_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/common/repositories/common_firebase_storage_repository.dart';
import 'dart:io';

final authRepositoryProvider=Provider(
      (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance),
);
class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });
  Future<UserModel?>getCurrentUserData() async {
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel ? user;
    if(userData.data()!=null){
      user=UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
            arguments: verificationId,);
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
    on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }
  void verifyOTP({
   required BuildContext context,
   required String verificationId,
   required String userOTP, 
   })async{
     try{
       PhoneAuthCredential credential=PhoneAuthProvider.credential(
           verificationId: verificationId,
           smsCode: userOTP);
       await auth.signInWithCredential(credential);
       Navigator.pushNamedAndRemoveUntil(context,UserInformationScreen.routeName,
               (route) => false);
     }on FirebaseAuthException catch(e){
       showSnackBar(context: context, content: e.message!);
     }
  }
  void saveUserDataToFirebase({
    required String name,
    required File?profilePic,
    required ProviderRef ref,
    required BuildContext context,
})async {
    try{
      String uid = auth.currentUser!.uid;
      String photoUrl='https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png';
     if(profilePic!=null){
     photoUrl = await ref
         .read(commonFirebaseStorageRepositoryProvider)
         .storeFileToFirebase(
       'profilePic/$uid',
       profilePic,);
     }
var user = UserModel(name:name,
  uid:uid,
  profilePic:photoUrl,
  isOnline:true,
  phoneNumber:auth.currentUser!.phoneNumber!,
  groupId:[],
);
    await firestore.collection('users').doc(uid).set(user.toMap());
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
      builder: (context)=>const MobileLayoutScreen(),
    ),
            (route)=>false
    );
    }catch (e){
      showSnackBar(context: context, content: e.toString());
    }
  }
  Stream<UserModel> userData(String userId){
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) =>
        UserModel.fromMap(
          event.data()!,
        ),);
  }
}