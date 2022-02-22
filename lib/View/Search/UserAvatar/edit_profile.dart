import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:livu/View/Search/UserAvatar/language.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'language.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/Search/UserAvatar/Interest.dart';
import 'UserProfile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/Services/UserDataServices.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:get/get.dart' hide Trans;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Color lite_grey_color = Color(0xff5a5d65);
  Color grey_color = Color(0xffb8bbc1);
  Color white_color = Colors.white;
  Color lite_black_color = Color(0xff1a1a1a);
  int _groupValue = 1;
  bool checkBoxValue = false;
  String userName;
  String location;
  String datetime = '';
  String age;
  final userdataCtr = Get.put(UserDataController());
  List<Language> languageData = Language().languageData();

  List<Interested> interestData = Interested().interestData();
  String bio = '';
  var _image1;
  var _image2;
  var _image3;
  var _image4;
  var _image5;
  var _image6;
  File videoFile;
  VlcPlayerController _videoPlayerController;

  List imageList = [];
  final _picker = ImagePicker();
  XFile video;
  dynamic uploadedVideoLink;
  Future getImageLibrary({indexValue}) async {
    imageList = userdataCtr.userModel.value.imageList;
    var gallery = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 700);
    var imagePath = File(gallery.path);

    if (gallery != null) {
      if (indexValue == 1) {
        _image1 = await UserDataServices()
            .uploadpetImage(imagePath, UniqueKey().toString());

        imageList.insert(0, _image1);
      } else if (indexValue == 2) {
        _image2 = await UserDataServices()
            .uploadpetImage(imagePath, UniqueKey().toString());

        imageList.insert(1, _image2);
      } else if (indexValue == 3) {
        _image3 = await UserDataServices()
            .uploadpetImage(imagePath, UniqueKey().toString());

        imageList.insert(2, _image3);
      } else if (indexValue == 4) {
        _image4 = await UserDataServices()
            .uploadpetImage(imagePath, UniqueKey().toString());

        imageList.insert(3, _image4);
      } else if (indexValue == 5) {
        _image5 = await UserDataServices()
            .uploadpetImage(imagePath, UniqueKey().toString());

        imageList.insert(4, _image5);
      } else if (indexValue == 6) {
        _image6 = await UserDataServices()
            .uploadpetImage(imagePath, UniqueKey().toString());

        imageList.insert(5, _image6);
      }

      UserDataServices().setImageList(imageList);
    }

    setState(() {
      Get.snackbar('Image Uploaded'.tr(), 'Your Image have been uploaded'.tr(),
          duration: Duration(seconds: 1), snackPosition: SnackPosition.BOTTOM);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      uploadedVideoLink = userdataCtr.userModel.value.videoLink;
    });
    if (userdataCtr.userModel.value.videoLink.length != 0) {
      _videoPlayerController = VlcPlayerController.network(uploadedVideoLink)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    userName = userdataCtr.userModel.value.name;
    location = userdataCtr.userModel.value.location;
    datetime = userdataCtr.userModel.value.birthDay;
    age = userdataCtr.userModel.value.age;

    imageList = userdataCtr.userModel.value.imageList;
    print(imageList);

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xff191919),
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GetX<UserDataController>(builder: (controller) {
                      print(controller.userModel.value.imageList.length);
                      return addContainer(
                          ontap: () {
                            getImageLibrary(indexValue: 1);
                          },
                          ontapToRemoceImage: () {
                            setState(() {
                              Get.back();
                              imageList.removeAt(0);
                              // print('this' + imageList.toString());

                              UserDataServices().setImageList(imageList);
                            });
                          },
                          selectedImage:
                              controller.userModel.value.imageList.length >= 1
                                  ? controller.userModel.value.imageList[0]
                                  : _image1,
                          id: _image1 == null ? true : false);
                    }),
                    GetX<UserDataController>(builder: (controller) {
                      //print(controller.userModel.value.imageList.length);
                      return addContainer(
                          ontap: () {
                            getImageLibrary(indexValue: 2);
                          },
                          ontapToRemoceImage: () {
                            setState(() {
                              Get.back();
                              imageList.removeAt(1);

                              UserDataServices().setImageList(imageList);
                            });
                          },
                          selectedImage:
                              controller.userModel.value.imageList.length >= 2
                                  ? controller.userModel.value.imageList[1]
                                  : _image2,
                          index: 1,
                          id: _image2 == null ? true : false);
                    }),
                    GetX<UserDataController>(builder: (controller) {
                      // print(controller.userModel.value.imageList.length);
                      return addContainer(
                          ontap: () {
                            getImageLibrary(indexValue: 3);
                          },
                          ontapToRemoceImage: () {
                            setState(() {
                              imageList.removeAt(2);
                              Get.back();

                              UserDataServices().setImageList(imageList);
                            });
                          },
                          index: 2,
                          selectedImage:
                              controller.userModel.value.imageList.length >= 3
                                  ? controller.userModel.value.imageList[2]
                                  : _image3,
                          id: _image3 == null ? true : false);
                    }),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GetX<UserDataController>(builder: (controller) {
                    //print(controller.userModel.value.imageList.length);
                    return addContainer(
                        ontap: () {
                          getImageLibrary(indexValue: 4);
                        },
                        ontapToRemoceImage: () {
                          setState(() {
                            Get.back();
                            imageList.removeAt(3);

                            UserDataServices().setImageList(imageList);
                          });
                        },
                        selectedImage:
                            controller.userModel.value.imageList.length >= 4
                                ? controller.userModel.value.imageList[3]
                                : _image4,
                        index: 3,
                        id: _image4 == null ? true : false);
                  }),
                  GetX<UserDataController>(builder: (controller) {
                    //print(controller.userModel.value.imageList.length);
                    return addContainer(
                        ontap: () {
                          getImageLibrary(indexValue: 5);
                        },
                        index: 4,
                        ontapToRemoceImage: () {
                          setState(() {
                            imageList.removeAt(4);
                            Get.back();

                            UserDataServices().setImageList(imageList);
                          });
                        },
                        selectedImage:
                            controller.userModel.value.imageList.length >= 5
                                ? controller.userModel.value.imageList[4]
                                : _image5,
                        id: _image4 == null ? true : false);
                  }),
                  GetX<UserDataController>(builder: (controller) {
                    //print(controller.userModel.value.imageList.length);
                    return addContainer(
                        ontap: () {
                          getImageLibrary(indexValue: 6);
                        },
                        ontapToRemoceImage: () {
                          setState(() {
                            imageList.removeAt(5);
                            Get.back();

                            UserDataServices().setImageList(imageList);
                          });
                        },
                        index: 5,
                        selectedImage:
                            controller.userModel.value.imageList.length >= 6
                                ? controller.userModel.value.imageList[5]
                                : _image6,
                        id: _image6 == null ? true : false);
                  }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    video = await ImagePicker()
                        .pickVideo(source: ImageSource.gallery);
                    uploadedVideoLink = await UserDataServices()
                        .uploadpetImage(video, UniqueKey().toString());
                    await UserDataServices().setVideo(uploadedVideoLink);
                    _videoPlayerController =
                        VlcPlayerController.network(uploadedVideoLink)
                          ..initialize().then((_) {
                            setState(() {});
                          });

                    Get.snackbar('Uploaded'.tr(),
                        'Your Video has been Uploaded successfully'.tr(),
                        snackPosition: SnackPosition.BOTTOM);
                    setState(() {});
                  },
                  child: Container(
                    color: greyColor,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 1,
                    child: uploadedVideoLink == ''
                        ? Icon(
                            Icons.video_library,
                            size: SizeConfig.imageSizeMultiplier * 30,
                            color: Colors.white.withOpacity(0.4),
                          )
                        : Stack(
                            children: [
                              VlcPlayer(
                                controller: _videoPlayerController,
                                aspectRatio: 16 / 9,
                                placeholder:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    UserDataServices().deleteVideo();
                                    setState(() {
                                      uploadedVideoLink = '';
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 20),
                    child: Text(
                      "sutitle_edit_profile",
                      style: TextStyle(color: Color(0xff5f5f5f), fontSize: 16),
                    ).tr(),
                  ),
                ],
              ),
              GetX<UserDataController>(
                builder: (controller) {
                  return listbar(
                    textTitle: "Name".tr(),
                    subTittle: controller.userModel.value.name,
                    textTraling:
                        controller.userModel.value.name.length.toString() +
                            '/30',
                    ontap: () {
                      _buildBottomModelForName();
                    },
                  );
                },
              ),
              GetX<UserDataController>(
                builder: (controller) {
                  return listbar(
                    textTitle: "Birthday".tr(),
                    subTittle: controller.userModel.value.birthDay,
                    id: 1,
                    ontap: () async {
                      await showDatePicker(
                              context: context,
                              initialDate: DateTime(2001),
                              firstDate: new DateTime(1900),
                              lastDate: new DateTime(2100))
                          .then((value) {
                        setState(() {
                          datetime = value.toString().substring(0, 10);
                          UserDataServices().setBirthday(datetime);
                        });
                      });
                    },
                  );
                },
              ),
              GetX<UserDataController>(
                builder: (controller) {
                  return listbar(
                    textTitle: "Personal_Bio".tr(),
                    subTittle: controller.userModel.value.bio == ''
                        ? 'Bio_Detail'.tr()
                        : controller.userModel.value.bio,
                    textTraling:
                        controller.userModel.value.bio.length.toString() +
                            "/140",
                    ontap: () {
                      _buildBottomModelForBio();
                    },
                  );
                },
              ),
              GetX<UserDataController>(
                builder: (controller) {
                  return listbar(
                    textTitle: "Location".tr(),
                    textTraling: '',
                    subTittle: controller.userModel.value.location == ''
                        ? 'Location_detail'.tr()
                        : controller.userModel.value.location,
                    ontap: () {
                      _buildBottomModelforLocation();
                    },
                  );
                },
              ),
              GetX<UserDataController>(
                builder: (controller) {
                  return listbar(
                    textTitle: "Age".tr(),
                    textTraling: '',
                    subTittle: controller.userModel.value.age == ''
                        ? 'Age_detail'
                        : controller.userModel.value.age,
                    ontap: () {
                      _buildBottomModelforAge();
                    },
                  );
                },
              ),
              _languageTile(),
              _interestTile(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 4,
      backgroundColor: greyColor,
      title: Text(
        "Edit_profile",
        style: TextStyle(color: Colors.white),
      ).tr(),
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => UserProfile(
                    userData: Get.find<UserDataController>().userModel.value,
                  ));
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: grey_color,
                    size: 16,
                  ),
                ),
                Text(
                  "Preview",
                  style: TextStyle(color: grey_color),
                ).tr()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget listbar(
      {String textTitle, String subTittle, String textTraling, int id, ontap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: ontap,
          child: ListTile(
            title: Text(
              textTitle,
              style: TextStyle(color: grey_color),
            ),
            subtitle: Text(
              subTittle,
              style: TextStyle(color: grey_color),
            ),
            trailing: id == 1
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: grey_color,
                    size: 16,
                  )
                : Text(
                    textTraling,
                    style: TextStyle(color: grey_color),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
          child: Divider(
            color: Colors.grey[600],
            height: SizeConfig.heightMultiplier * 0.5,
          ),
        ),
      ],
    );
  }

  Widget addContainer(
      {Function ontap,
      selectedImage,
      bool id,
      int index,
      Function ontapToRemoceImage}) {
    // print(selectedImage);
    return GestureDetector(
      onTap: ontap,
      child: Stack(
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 30,
            height: SizeConfig.heightMultiplier * 20,
            color: lite_grey_color,
            child: Container(
              width: SizeConfig.widthMultiplier * 5,
              height: SizeConfig.widthMultiplier * 5,
              color: greyColor,
              child: selectedImage == null
                  ? SizedBox()
                  : Stack(
                      children: [
                        selectedImage != ''
                            ? Image.network(
                                selectedImage,
                                width: SizeConfig.widthMultiplier * 30,
                                height: SizeConfig.heightMultiplier * 20,
                                fit: BoxFit.fill,
                              )
                            : Positioned(
                                top: SizeConfig.heightMultiplier * 8,
                                left: SizeConfig.widthMultiplier * 10,
                                child: id == false
                                    ? SizedBox()
                                    : Icon(
                                        Icons.add,
                                        size: 40,
                                        color: lite_grey_color,
                                      ),
                              ),
                        Positioned(
                          top: 5,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: greyColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showMaterialModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        color: greyColor,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: ontapToRemoceImage,
                                              leading: Icon(Icons.delete,
                                                  color: Colors.red),
                                              title: Text('Remove',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            ListTile(
                                              onTap: () => Get.back(),
                                              leading: Icon(
                                                Icons.cancel,
                                                color: Colors.green,
                                              ),
                                              title: Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: greyColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          selectedImage != null
              ? SizedBox()
              : Positioned(
                  top: SizeConfig.heightMultiplier * 8,
                  left: SizeConfig.widthMultiplier * 10,
                  child: id == false
                      ? SizedBox()
                      : Icon(
                          Icons.add,
                          size: 40,
                          color: lite_grey_color,
                        ),
                ),
        ],
      ),
    );
  }

  _buildBottomModelForName() {
    print(userName);
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Container(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            initialValue: userdataCtr.userModel.value.name,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            maxLength: 30,
                            onChanged: (value) {
                              userName = value;
                            },
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Name',
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      UserDataServices().setUserName(userName);
                      Get.back();
                      setState(() {
                        userName = userdataCtr.userModel.value.name;
                      });
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Center(
                        child: Text(
                          'Save_Button',
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomModelForBio() {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal_Bio',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ).tr(),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Container(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            initialValue: userdataCtr.userModel.value.bio,
                            maxLines: 5,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            maxLength: 150,
                            onChanged: (value) {
                              bio = value;
                            },
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Personal_Bio'.tr(),
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      UserDataServices().setBio(bio);
                      Get.back();
                      setState(() {});
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Center(
                        child: Text(
                          'Save_Button',
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _languageTile() {
    return GetX<UserDataController>(builder: (controller) {
      return ListTile(
        onTap: () => Get.to(() => LanguagePage()).then((value) {
          setState(() {});
        }),
        title: Text(
          "Language",
          style: TextStyle(color: grey_color),
        ).tr(),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                height: SizeConfig.heightMultiplier * 4,
                width: SizeConfig.widthMultiplier * 80,
                child: controller.userModel.value.languages.length != 0
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.userModel.value.languages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Container(
                              height: SizeConfig.heightMultiplier * 2,
                              width: SizeConfig.widthMultiplier * 22,
                              decoration: BoxDecoration(
                                color: purpleColor.withOpacity(0.6),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Center(
                                child: (Text(
                                  languageData[controller
                                          .userModel.value.languages[index]]
                                      .languageName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.3),
                                )),
                              ),
                            ),
                          );
                        })
                    : Text('LanguageDetail',
                        style: TextStyle(
                          color: Colors.grey,
                        )).tr(),
              )
            ],
          ),
        ),
      );
    });
  }

  _interestTile() {
    return GetX<UserDataController>(builder: (controller) {
      print(controller.userModel.value.interest.length);
      return ListTile(
        onTap: () => Get.to(() => Interest()).then((value) {
          setState(() {});
        }),
        title: Text(
          "Interest",
          style: TextStyle(color: grey_color),
        ).tr(),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              controller.userModel.value.interest.length != 0
                  ? Container(
                      height: SizeConfig.heightMultiplier * 4,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.userModel.value.interest.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                height: SizeConfig.heightMultiplier * 2,
                                width: SizeConfig.widthMultiplier * 22,
                                decoration: BoxDecoration(
                                  color: purpleColor.withOpacity(0.6),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                padding: EdgeInsets.all(6),
                                child: Center(
                                  child: (Text(
                                    interestData[controller
                                            .userModel.value.interest[index]]
                                        .interest,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.3),
                                  )),
                                ),
                              ),
                            );
                          }),
                    )
                  : Text('Interest_Detail',
                      style: TextStyle(
                        color: Colors.grey,
                      )).tr(),
            ],
          ),
        ),
      );
    });
  }

  _buildBottomModelforAge() {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ).tr(),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Container(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            initialValue: userdataCtr.userModel.value.age,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            maxLength: 3,
                            onChanged: (value) {
                              age = value;
                            },
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Age'.tr(),
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      UserDataServices().setAge(age);
                      Get.back();
                      setState(() {
                        age = userdataCtr.userModel.value.age;
                      });
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Center(
                        child: Text(
                          'Save_Button'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomModelforLocation() {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ).tr(),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Container(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            initialValue: userdataCtr.userModel.value.location,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            maxLength: 50,
                            onChanged: (value) {
                              location = value;
                            },
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Location'.tr(),
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      UserDataServices().setLocataion(location);
                      Get.back();
                      setState(() {
                        location = userdataCtr.userModel.value.location;
                      });
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Center(
                        child: Text(
                          'Save_Button',
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
