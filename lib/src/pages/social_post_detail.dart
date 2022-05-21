import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:health_app/src/config/api_url.dart';
import 'package:health_app/src/model/comment_model.dart';
import 'package:health_app/src/model/post_model.dart';
import 'package:health_app/src/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/user_provider.dart';

class SocialPostDetail extends StatefulWidget {
  const SocialPostDetail({Key key}) : super(key: key);

  @override
  State<SocialPostDetail> createState() => _SocialPostDetailState();
}

class _SocialPostDetailState extends State<SocialPostDetail> {
  bool islike;
  TextEditingController _cmtController = TextEditingController();
  bool _submitted = true;

  @override
  Widget build(BuildContext context) {
    final List<String> imagesList = [];
    List<Comment> cmtsList = [];
    //Vali
    String _errcmt() {
      final text = _cmtController.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      return null;
    }

    //User
    User user;
    user = Provider.of<UserProvider>(context).user;
    // Post
    PostProvider postProvider = Provider.of<PostProvider>(context);
    Post post = ModalRoute.of(context).settings.arguments;
    post.posts_imgs.forEach(
      (e) {
        setState(() {
          imagesList.add(API_URL.getImage + e.name.toString());
        });
      },
    );
    post.comments.forEach(
      (e) {
        cmtsList.add(e);
      },
    );
    post.likes.forEach(
      (e) {
        if (e.id_user == user.id) {
          setState(() {
            islike = true;
          });
        } else {
          setState(() {
            islike = false;
          });
        }
      },
    );
    // Loading
    var loading = Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Text(" Đang xử lý ...")
        ],
      ),
    );

    //Xóa post
    deletePost(int id_post) async {
      bool result = await postProvider.deletePost(id_post);
      if (result == true) {
        Navigator.pop(context, true);
      } else {
        Flushbar(
          title: "Thông báo",
          message: "Xóa thất bại",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    //Like post
    likePost(int id_post) async {
      bool result = await postProvider.likePost(id_post);
      if (result == true) {
        setState(() {
          islike = true;
        });
      } else {
        setState(() {
          islike = false;
        });
        Flushbar(
          title: "Thông báo",
          message: "Thích thất bại",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    //unLike post
    unlikePost(int id_post) async {
      bool result = await postProvider.unlikePost(id_post);
      if (result == true) {
        setState(() {
          islike = false;
        });
      } else {
        setState(() {
          islike = true;
        });
        Flushbar(
          title: "Thông báo",
          message: "Hủy thích thất bại",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    // Bình luận
    cmtPost(int id_post, String content) async {
      bool result = await postProvider.commentPost(id_post, content);
      if (result == true) {
        List<Comment> listC = await postProvider.getComment(id_post);
        setState(() {
          cmtsList = listC;
        });
        Flushbar(
          title: "Thông báo",
          message: "Bình luận thành công",
          duration: Duration(seconds: 2),
        ).show(context);
      } else {
        setState(() {
          islike = true;
        });
        Flushbar(
          title: "Thông báo",
          message: "Bình luận thất bại",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            padding: const EdgeInsets.all(0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("Trở về"),
                            ),
                          ),
                        ),
                        post.user.id == user.id
                            ? Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                      ),
                                      padding: const EdgeInsets.all(0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text("Chỉnh sửa"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  postProvider.deleteInStatus == Status.Deleting
                                      ? loading
                                      : ElevatedButton(
                                          onPressed: () {
                                            deletePost(post.id);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(80.0),
                                            ),
                                            padding: const EdgeInsets.all(0),
                                            primary: Colors.redAccent,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text("Xóa"),
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    Html(
                      data: post.content,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                      ),
                      items: imagesList
                          .map(
                            (item) => Center(
                              child: Image.network(
                                item,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    islike == true
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  unlikePost(post.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 36.0,
                                  ),
                                ),
                              ),
                              Text(" đã thích")
                            ],
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  likePost(post.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black45,
                                    size: 36.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Bình luận"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _cmtController,
                            decoration: InputDecoration(
                              errorText: !_submitted ? _errcmt() : null,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cmtPost(post.id, _cmtController.text);
                            },
                            child: Text(
                              "GỬI",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: cmtsList.length,
                      itemBuilder: (context, index) {
                        Comment cmt = cmtsList[index];
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${cmt.user.full_name.toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${cmt.content}",
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
