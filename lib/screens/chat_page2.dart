import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../allConstants/color_constants.dart';
import '../allConstants/firestore_constants.dart';
import '../allConstants/size_constants.dart';
import '../allConstants/text_field_constants.dart';
import '../allWidgets/common_widgets.dart';
import '../models/chat_messages.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/profile_provider.dart';
import 'login_page.dart';

class ChatPage2 extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  const ChatPage2(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar})
      : super(key: key);

  @override
  State<ChatPage2> createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
  }

  Future getImage() async { // 채팅 보낼때 기기에서 이미지 선택할 수 있게해주는 함수
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void _callPhoneNumber(String phoneNumber) async {
    var url = 'tel://$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error Occurred';
    }
  }

  void uploadImageFile() async { // 채팅 중인 사용자에게 이미지를 보내고 Firebase 저장소에 이미지를 저장하고 해당 URL 정보를 Firestore 데이터베이스에 저장
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    // create a method to send chat messages and execute our sendChatMessage function from our ChatProvider class
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendChatMessage(
          content, type, groupChatId, currentUserId, widget.peerId);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // checking if received message
  bool isMessageReceived(int index) { // 채팅메세지 전송됬는지 확인
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) { // 채팅메세지 받았는지 확인
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar:AppBar(
            backgroundColor:Colors.white,
            title:const Text(
                '우체통',
                style:TextStyle(
                    color:Colors.black,
                    fontWeight:FontWeight.w500,
                    fontFamily:"NotoSansCJKKR",
                    fontSize:25.0
                )
            ),
            bottom:const TabBar(
                tabs:<Widget>[
                  Tab(
                    child:Text(
                        '받은편지함',
                        style:TextStyle(
                            color:Colors.black,
                            fontSize:13.0
                        )
                    ),
                  ),
                  Tab(
                    child:Text(
                        '보낸편지함',
                        style:TextStyle(
                            color:Colors.black,
                            fontSize:13.0
                        )
                    ),
                  ),
                  Tab(
                    child:Text(
                        '내게 쓴 편지',
                        style:TextStyle(
                            color:Colors.black,
                            fontSize:11.0
                        )
                    ),
                  ),
                  Tab(
                    child:Text(
                        '즐겨찾기',
                        style:TextStyle(
                            color:Colors.black,
                            fontSize:13.0
                        )
                    ),
                  )
                ]
            ),
          ),
          body:TabBarView(
              children:<Widget>[
                buildListMessage(),
                _buildLetterList2(),
                _buildLetterList3(),
                _buildLetterList4()
              ]
          )
      ),
    );
  }

  // Widget buildMessageInput() { // 사용자가 문자 메시지를 입력하고 보내기 버튼을 클릭하여 메시지를 보낼 입력 필드를 만들어야 합니다 .
  //   // 또한 이미지 선택기 버튼을 사용하여 사용자가 클릭하면 장치의 파일 선택기가 열리고 이미지를 선택하여 사용자에게 보냅니다.
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 50,
  //     child: Row(
  //       children: [
  //         Container(
  //           margin: const EdgeInsets.only(right: Sizes.dimen_4),
  //           decoration: BoxDecoration(
  //             color: AppColors.burgundy,
  //             borderRadius: BorderRadius.circular(Sizes.dimen_30),
  //           ),
  //           child: IconButton(
  //             onPressed: getImage,
  //             icon: const Icon(
  //               Icons.camera_alt,
  //               size: Sizes.dimen_28,
  //             ),
  //             color: AppColors.white,
  //           ),
  //         ),
  //         Flexible(
  //             child: TextField(
  //           focusNode: focusNode,
  //           textInputAction: TextInputAction.send,
  //           keyboardType: TextInputType.text,
  //           textCapitalization: TextCapitalization.sentences,
  //           controller: textEditingController,
  //           decoration:
  //               kTextInputDecoration.copyWith(hintText: 'write here...'),
  //           onSubmitted: (value) {
  //             onSendMessage(textEditingController.text, MessageType.text);
  //           },
  //         )),
  //         Container(
  //           margin: const EdgeInsets.only(left: Sizes.dimen_4),
  //           decoration: BoxDecoration(
  //             color: AppColors.burgundy,
  //             borderRadius: BorderRadius.circular(Sizes.dimen_30),
  //           ),
  //           child: IconButton(
  //             onPressed: () {
  //               onSendMessage(textEditingController.text, MessageType.text);
  //             },
  //             icon: const Icon(Icons.send_rounded),
  //             color: AppColors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    // 프로필 사진과 함께 주고받은 문자 메시지에 대한 채팅 풍선을 생성합니다.
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        chatContent: chatMessages.content,
                        color: AppColors.spaceLight,
                        textColor: AppColors.white,
                        margin: const EdgeInsets.only(right: Sizes.dimen_10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(
                                right: Sizes.dimen_10, top: Sizes.dimen_10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.dimen_20),
                        ),
                        child: Image.network(
                          widget.userAvatar,
                          width: Sizes.dimen_40,
                          height: Sizes.dimen_40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.burgundy,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: AppColors.greyColor,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
              ],
            ),
            isMessageSent(index)
                ? Container(
                    margin: const EdgeInsets.only(
                        right: Sizes.dimen_50,
                        top: Sizes.dimen_6,
                        bottom: Sizes.dimen_8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: Sizes.dimen_12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)
                    // left side (received message)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.dimen_20),
                        ),
                        child: Image.network(
                          widget.peerAvatar,
                          width: Sizes.dimen_40,
                          height: Sizes.dimen_40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.burgundy,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: AppColors.greyColor,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        color: AppColors.burgundy,
                        textColor: AppColors.white,
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(left: Sizes.dimen_10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(
                                left: Sizes.dimen_10, top: Sizes.dimen_10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(
                        left: Sizes.dimen_50,
                        top: Sizes.dimen_6,
                        bottom: Sizes.dimen_8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: Sizes.dimen_12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatMessage(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]));
                  } else {
                    return const Center(
                      child: Text('No messages...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.burgundy,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.burgundy,
              ),
            ),
    );
  }
}

Widget _buildLetterList2(){ //받은 편지 리스트 위젯
  return Column();
}



Widget _buildLetterList3(){ //받은 편지 리스트 위젯
  return Column(

  );
}


Widget _buildLetterList4(){ //받은 편지 리스트 위젯
  return Column(

  );
}