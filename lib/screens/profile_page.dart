import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../allConstants/app_constants.dart';
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
      Fluttertoast.showToast(msg: 'UpdateSuccess');
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation:0.0,
              centerTitle: true,
              title: const Text(
                '마이페이지',
                style: TextStyle(color:Colors.black),
              ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              width: 120,
                              height: 120,
                              errorBuilder: (context, object, stackTrace) {
                                return const Icon(Icons.account_circle, size: 90,
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
                            child: Image.file(avatarImageFile!, width: 120,
                              height: 120,
                              fit: BoxFit.cover,),),
                          margin: const EdgeInsets.all(20),
                        ),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            decoration: kTextInputDecoration.copyWith(
                                hintText: '이름을 적어주세요'),
                            controller: displayNameController,
                            onChanged: (value) {
                              displayName = value;
                            },
                            focusNode: focusNodeNickname,
                          ),
                          SizedBox(height:50),
                          vertical15,
                            Card(
                              child:ListTile(
                                title: const Text(
                                    '잠긴편지 보내기',
                                    style: TextStyle(
                                        color:Color(0xff433e50),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansCJKKR",
                                        fontStyle:FontStyle.normal,
                                        fontSize: 20.0
                                    ),
                                    textAlign: TextAlign.left
                                ),
                                onTap: (){
                                  print('잠긴편지보내기');
                                },
                                trailing: Icon(Icons.add,color:Colors.blue),
                              ),
                            ),
                            Card(
                              child:ListTile(
                                title: Text(
                                    '친구 목록 관리',
                                    style: TextStyle(
                                        color:Color(0xff433e50),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansCJKKR",
                                        fontStyle:FontStyle.normal,
                                        fontSize: 20.0
                                    ),
                                    textAlign: TextAlign.left
                                ),
                                onTap: (){
                                  print('친구 목록 관리');
                                },
                                trailing: Icon(Icons.add,color:Colors.blue),
                              ),
                            ),
                            Card(
                              child:ListTile(
                                title: const Text(
                                    '구매 목록 관리',
                                    style: TextStyle(
                                        color:Color(0xff433e50),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansCJKKR",
                                        fontStyle:FontStyle.normal,
                                        fontSize: 20.0
                                    ),
                                    textAlign: TextAlign.left
                                ),
                                onTap: (){
                                  print('구매 목록 관리');
                                },
                                trailing: Icon(Icons.add,color:Colors.blue),
                              ),
                            ),
                            SizedBox(height:50),
                          ],
                      ),
                      const Text(
                        '즐겨찾는 필체',
                        style: TextStyle(
                            color:  Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 70,
                                  height:70,
                                  child:Image(
                                    image:AssetImage('assets/images/before_login.png'),
                                  )
                              ),
                              const Text(
                                  "김채원체",
                                  style: TextStyle(
                                      color:Color(0xff000000),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "S-CoreDream-3",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 18.0
                                  ),
                                  textAlign: TextAlign.left
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 70,
                                  height:70,
                                  child:Image(
                                    image:AssetImage('assets/images/before_login.png'),
                                  )
                              ),
                              const Text(
                                  "방진욱체",
                                  style: TextStyle(
                                      color:Color(0xff000000),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "S-CoreDream-3",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 18.0
                                  ),
                                  textAlign: TextAlign.left
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 70,
                                  height:70,
                                  child:const Image(
                                    image:AssetImage('assets/images/before_login.png'),
                                  )
                              ),
                              const Text(
                                  "장도진체",
                                  style: TextStyle(
                                      color:Color(0xff000000),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "S-CoreDream-3",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 18.0
                                  ),
                                  textAlign: TextAlign.left
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 70,
                                  height:70,
                                  child:const Image(
                                    image:AssetImage('assets/images/before_login.png'),
                                  )
                              ),
                              const Text(
                                  "유혜린체",
                                  style: TextStyle(
                                      color:Color(0xff000000),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "S-CoreDream-3",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 18.0
                                  ),
                                  textAlign: TextAlign.left
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 100),
                      ElevatedButton(onPressed: updateFirestoreData, child:const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Text('프로필 업데이트'),
                      )),

                    ],
                  ),
                ),
              Positioned(child: isLoading ? const LoadingView() : const SizedBox.shrink()),
            ],
          ),

        );

  }
}
