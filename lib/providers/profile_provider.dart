import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttergooglesignin/allConstants/all_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final Map<String,dynamic> profileMap = {};
  ProfileProvider(
      {required this.prefs,
      required this.firebaseStorage,
      required this.firebaseFirestore});

  void init()async{
    QuerySnapshot<Map<String, dynamic>> k = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .get();
   Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> j =k.docs.asMap();
   for(int p = 0;p<j.length;p++){
     profileMap[j[p]!.data()['id']] = {'displayName':j[p]!.data()['displayName'],'photoUrl':j[p]!.data()['photoUrl'],};
   }
  }



  String? getPrefs(String key) {
    return prefs.getString(key);
  }

  Future<bool> setPrefs(String key, String value) async {
    return await prefs.setString(key, value);
  }

  UploadTask uploadImageFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(String collectionPath, String path,
      Map<String, dynamic> dataUpdateNeeded) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataUpdateNeeded);
  }
}
