import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../allConstants/firestore_constants.dart';
import '../models/chat_messages.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider(
      {required this.prefs,
      required this.firebaseStorage,
      required this.firebaseFirestore});

  UploadTask uploadImageFile(File image, String filename) { // Firebase 저장소에 이미지 파일을 업로드
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData( //서로 채팅할 사용자 ID와 관련된 Firestore 데이터베이스 정보를 업데이트
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) { //사용자가 서로 채팅하는 동안 Firestore 데이터베이스에서 채팅 메시지 스트림을 가져오기
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getMailStream(String userId, int limit) { //한 사용자에게 수신된 메시지 가져오기
    return firebaseFirestore
        .collection(FirestoreConstants.mailbox)
        .doc(userId)
        .collection(FirestoreConstants.mailbox)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getSendMailStream(String userId, int limit) { //한 사용자에게 수신된 메시지 가져오기
    return firebaseFirestore
        .collection(FirestoreConstants.sendmailbox)
        .doc(userId)
        .collection(FirestoreConstants.sendmailbox)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getChatProfile(String userId) async{ //한 사용자에게 수신된 메시지 가져오기
    DocumentSnapshot<Map<String, dynamic>> doc =  await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(userId)
        .get();
    return doc;
  }



  void sendMail (String content, int type, // Firestore 데이터베이스의 도움으로 다른 사용자에게 메시지를 보내고 그 안에 해당 메시지를 저장
      String currentUserId, String peerId) {
    String now = DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.mailbox)
        .doc(peerId).collection(FirestoreConstants.mailbox)
        .doc(now);

    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: now,
        content: content, // 여기에 메세지 내용이 담김
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson()); // 위에 chatMessages에서 받아왔던 currentUserId, peerId , 등등이 toJson으로 전달됨
    });

    DocumentReference documentReferencetome = firebaseFirestore
        .collection(FirestoreConstants.sendmailbox)
        .doc(currentUserId).collection(FirestoreConstants.sendmailbox)
        .doc(now);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReferencetome, chatMessages.toJson()); // for send message 받아왔던 currentUserId, peerId , 등등이 toJson으로 전달됨
    });

  }


  void sendChatMessage(String content, int type, String groupChatId, // Firestore 데이터베이스의 도움으로 다른 사용자에게 메시지를 보내고 그 안에 해당 메시지를 저장
      String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content, // 여기에 메세지 내용이 담김
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson()); // 위에 chatMessages에서 받아왔던 currentUserId, peerId , 등등이 toJson으로 전달됨
    });
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
