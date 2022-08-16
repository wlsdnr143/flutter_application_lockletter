import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../allConstants/color_constants.dart';
import '../allConstants/firestore_constants.dart';
import '../allConstants/text_field_constants.dart';
import '../allWidgets/loading_view.dart';
import '../models/chat_user.dart';
import '../providers/profile_provider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool _visibility = false;

  void _show() {
    setState(() {
      _visibility = true;
    });
  }
  void _hide() {
    setState(() {
      _visibility = false;
    });
  }

  TextEditingController? displayNameController;
  TextEditingController? aboutMeController;
  final TextEditingController _phoneController = TextEditingController();

  late String currentUserId;
  String dialCodeDigits = '+00';
  String id = '';
  String displayName = '';
  String photoUrl = '';
  String phoneNumber = '';
  String aboutMe = '';

  bool isLoading = false;
  File? avatarImageFile;
  late ProfileProvider profileProvider;

  final FocusNode focusNodeNickname = FocusNode();

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    readLocal();
  }

  void readLocal() {
    setState(() {
      id = profileProvider.getPrefs(FirestoreConstants.id) ?? "";
      displayName = profileProvider.getPrefs(FirestoreConstants.displayName) ?? "";

      photoUrl = profileProvider.getPrefs(FirestoreConstants.photoUrl) ?? "";
      // phoneNumber =
      //     profileProvider.getPrefs(FirestoreConstants.phoneNumber) ?? "";
      aboutMe = profileProvider.getPrefs(FirestoreConstants.aboutMe) ?? "";
    });
    displayNameController = TextEditingController(text: displayName);
    aboutMeController = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    // PickedFile is not supported
    // Now use XFile?
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString())
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask = profileProvider.uploadImageFile(
        avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      ChatUser updateInfo = ChatUser(id: id,
          photoUrl: photoUrl,
          displayName: displayName,
          // phoneNumber: phoneNumber,
          aboutMe: aboutMe);
      profileProvider.updateFirestoreData(
          FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
          .then((value) async {
        await profileProvider.setPrefs(FirestoreConstants.photoUrl, photoUrl);
        setState(() {
          isLoading = false;
        });
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void updateFirestoreData() {
    focusNodeNickname.unfocus();
    setState(() {
      isLoading = true;
      if (dialCodeDigits != "+00" && _phoneController.text != "") {
        phoneNumber = dialCodeDigits + _phoneController.text.toString();
      }
    });
    ChatUser updateInfo = ChatUser(id: id,
        photoUrl: photoUrl,
        displayName: displayName,
        // phoneNumber: phoneNumber,
        aboutMe: aboutMe);
    profileProvider.updateFirestoreData(
        FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
        .then((value) async {
      await profileProvider.setPrefs(
          FirestoreConstants.displayName, displayName);
      // await profileProvider.setPrefs(
      //     FirestoreConstants.phoneNumber, phoneNumber);
      await profileProvider.setPrefs(
        FirestoreConstants.photoUrl, photoUrl,);
      await profileProvider.setPrefs(
          FirestoreConstants.aboutMe,aboutMe );

      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: '변경이 완료되었습니다');
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation:0.0,
              centerTitle: false,
              title: const Text(
                '  마이페이지',
                style: TextStyle(color:Colors.black),
              ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: getImage,
                              child: Container(
                                alignment: Alignment.center,
                                child: avatarImageFile == null ? photoUrl.isNotEmpty ?
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(photoUrl,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                    errorBuilder: (context, object, stackTrace) {
                                      return const Icon(Icons.account_circle, size: 120,
                                        color: AppColors.greyColor,);
                                    },
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return SizedBox(
                                        width: 90,
                                        height: 90,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.grey,
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes! : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ) : const Icon(Icons.account_circle,
                                  size: 90,
                                  color: AppColors.greyColor,)
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.file(avatarImageFile!, width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,),),
                                margin: const EdgeInsets.all(20),
                              ),),
                            Column(
                              children: [
                                Container(
                                  width: 200,
                                  child: TextField(
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "NotoSansKR_Regular",
                                    ),
                                    decoration: InputDecoration(
                                      //icon: Icon(Icons.person),
                                      suffixIcon: GestureDetector(
                                          child: const Icon(Icons.settings),
                                        onTap: ()
                                          {_visibility? _hide() : _show();},
                                      ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            )
                                        )
                                    ),
                                    controller: displayNameController,
                                    onChanged: (value) {
                                      displayName = value;
                                    },
                                    focusNode: focusNodeNickname,
                                  ),
                                ),
                                Text(
                                  '잠긴 글자: 0 글자                        ',
                                  style: TextStyle(color:Color(0xff999999),
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "NotoSansKR_Regular",),

                                ),
                                Text(
                                  '보낸 편지 수: 0 장                       ',
                                  style: TextStyle(color:Color(0xff999999),
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "NotoSansKR_Regular",),
                                ),
                              ],
                            ),
                          ],
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Visibility(
                            visible: _visibility,
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(50,30) // 버튼 크기를 지정해서 바꾸기
                                ),
                                onPressed: updateFirestoreData,
                                child:const Padding(
                              padding:  EdgeInsets.all(5.0),
                              child:  Text('사용자 이름 변경'),
                            )),
                          ),
                          vertical15,
                            // Card(
                            //   child:ListTile(
                            //     title: const Text(
                            //         '즐겨찾기 목록 관리',
                            //         style: TextStyle(
                            //             color:Color(0xff433e50),
                            //             fontWeight: FontWeight.w400,
                            //             fontFamily: "AppleSDGothicNeo",
                            //             fontStyle:FontStyle.normal,
                            //             fontSize: 20.0
                            //         ),
                            //         textAlign: TextAlign.left
                            //     ),
                            //     onTap: (){
                            //       print('즐겨찾기 목록 관리');
                            //     },
                            //     trailing: Icon(Icons.add,color:Colors.blue),
                            //   ),
                            // ),
                            Card(
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: const Text(
                                      '친구 목록 관리',
                                      style: TextStyle(
                                          color:Color(0xff433e50),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "NotoSansKR_Regular",
                                          fontStyle:FontStyle.normal,
                                          fontSize: 20.0
                                      ),
                                      textAlign: TextAlign.left
                                  ),
                                  onTap: (){
                                  },
                                  trailing: Icon(Icons.add,color:Colors.blue),
                                ),
                              ),
                            ),
                            Card(
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: const Text(
                                      '구매 목록 관리',
                                      style: TextStyle(
                                          color:Color(0xff433e50),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "NotoSansKR_Regular",
                                          fontStyle:FontStyle.normal,
                                          fontSize: 20.0
                                      ),
                                      textAlign: TextAlign.left
                                  ),
                                  onTap: (){
                                  },
                                  trailing: Icon(Icons.add,color:Colors.blue),
                                ),
                              ),
                            ),
                            SizedBox(height:30),
                          ],
                      ),
                      Container( height:8.0,
                        width:1000.0,
                        color:Color(0xfff1f1f5),),
                      SizedBox(height:30),
                      const Text(
                        '즐겨찾는 필체',
                        style: TextStyle(
                            color:  Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansKR_Regular",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
                        ),
                        textAlign: TextAlign.left,
                      ), // 즐겨찾는 필체 글씨
                      const SizedBox(height: 20),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              width: 85,
                              height:100,
                              child: Image.asset('assets/images/favorite1.png', fit: BoxFit.fitWidth)
                          ),
                          Container(
                              width: 85,
                              height:100,
                              child: Image.asset('assets/images/favorite2.png', fit: BoxFit.fitWidth)
                          ),
                          Container(
                              width: 85,
                              height:100,
                              child: Image.asset('assets/images/favorite3.png', fit: BoxFit.fitWidth)
                          ),
                          Container(
                              width: 85,
                              height:100,
                              child: Image.asset('assets/images/favorite4.png', fit: BoxFit.fitWidth)
                          ),
                        ],
                      ), // 즐겨찾는 필체 사진 모음
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              Positioned(child: isLoading ? const LoadingView() : const SizedBox.shrink()),
            ],
          ),

        );

  }
}
