import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/providers/post_provider.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SocialAddPostPage extends StatefulWidget {
  const SocialAddPostPage({Key key}) : super(key: key);

  @override
  State<SocialAddPostPage> createState() => _SocialAddPostPageState();
}

class _SocialAddPostPageState extends State<SocialAddPostPage> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  String content;

  // Upload hình ảnh
  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {
          imagefiles = pickedfiles;
          print(imagefiles.toString());
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Mở Camera
  getCamera() async {
    try {
      var imagee = await imgpicker.pickImage(source: ImageSource.camera);
      if (imagee != null) {
        setState(() {
          imagefiles.insert(0, imagee);
          print(imagefiles.toString());
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var loading = Padding(
    padding: EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        SizedBox(
          width: 20,
        ),
        Text(" Đang xử lý ...")
      ],
    ),
  );

  HtmlEditorController controller = HtmlEditorController();
  @override
  Widget build(BuildContext context) {
    // Thêm bài đăng
    PostProvider postProvider = Provider.of<PostProvider>(context);
    addPost(String contentpost, List<XFile> files) async {
      if (contentpost != null && contentpost.length > 0) {
        bool result = await postProvider.addPost(contentpost, files);

        if (result) {
          Flushbar(
            title: "Thông báo",
            message: "Thêm thành công",
            duration: Duration(seconds: 2),
          ).show(context);
        } else {
          Flushbar(
            title: "Thông báo",
            message: "Thêm thất bại",
            duration: Duration(seconds: 2),
          ).show(context);
        }
      } else {
        Flushbar(
          title: "Thông báo",
          message: "Nội dung không được để trống",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              child: Text("Trở về"),
                            ),
                          ),
                          postProvider.createInStatus == Status.Creating
                              ? loading
                              : ElevatedButton(
                                  onPressed: () async {
                                    String t = await controller.getText();
                                    addPost(t, imagefiles);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    child: Text("Đăng"),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      HtmlEditor(
                        controller: controller, //required
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: "Your text here...",
                          //initalText: "text content initial, if any",
                        ),
                        otherOptions: OtherOptions(
                          height: 500,
                        ),
                        htmlToolbarOptions: HtmlToolbarOptions(
                            toolbarType: ToolbarType.nativeGrid),
                      ),
                      //open button ----------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                openImages();
                              },
                              child: Text("Mở hình ảnh")),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                getCamera();
                              },
                              child: Text("Mở camera")),
                        ],
                      ),
                      imagefiles != null && imagefiles != []
                          ? Container(
                              child: Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: imagefiles.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          child: Card(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          child: Image.file(
                                              File(imagefiles[index].path)),
                                        ),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
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
