import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../config/api_url.dart';
import '../model/post_model.dart';
import '../model/user_model.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/post_add.dart';
import '../widgets/post_item.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  List<Post> listPosts = [];
  int pageSize = 5;
  int position = 0;
  var urls = <String>[
    'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
    'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  ];
  @override
  void initState() {
    // id = widget.id;
    // Hàm này để gọi func trước khi render
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getUserPosts();
      });
    }
    super.initState();
  }

  getUserPosts() async {
    var fetchedPost = await Provider.of<PostProvider>(context, listen: false)
        .getUserPosts(position, pageSize);
    setState(() {
      listPosts = fetchedPost["listPost"];
    });
    print("post list view : " + listPosts.toString());
  }

  void _loadmore() async {
    var fetchedPost = await Provider.of<PostProvider>(context, listen: false)
        .getUserPosts(position + 5, pageSize + 5) as List<Post>;
    if (fetchedPost != null &&
        fetchedPost.isNotEmpty &&
        fetchedPost.length > 0) {
      setState(() {
        listPosts.addAll(fetchedPost);
        position += 5;
        pageSize += 5;
      });
    }
  }

  RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;
    // reset dữ liệu
    void _onRefresh() async {
      // monitor network fetch
      var fetchedPost = await Provider.of<PostProvider>(context, listen: false)
          .getUserPosts(0, 5);
      setState(() {
        listPosts = fetchedPost["listPost"];
        position = 0;
        pageSize = 5;
      });
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }

    // Loading dữ liệu
    void _onLoading() async {
      var fetchedPost = await Provider.of<PostProvider>(context, listen: false)
          .getUserPosts(position + 5, pageSize + 5);
      if (fetchedPost["listPost"] != null &&
          fetchedPost["listPost"].isNotEmpty &&
          fetchedPost["listPost"].length > 0) {
        setState(() {
          listPosts.addAll(fetchedPost["listPost"]);
          position += 5;
          pageSize += 5;
        });
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Kéo để cập nhật");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Tải thất bại! Vui lòng nhấn lại !");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Đang sẵn sàng tải thêm");
            } else {
              body = Text("Không có dữ liệu thêm");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5 - 40,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            color: Colors.blue,
                            height: 180,
                            child: Image.asset(
                              "assets/top1.png", // ảnh bìa
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Positioned(
                          left: (MediaQuery.of(context).size.width / 2) - 60,
                          top: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              API_URL.getImage + user.avatar_url,
                              height: 120,
                              width: 120,
                            ),
                          )),
                      Positioned(
                        left: 0,
                        top: 242,
                        child: Container(
                          height: 700,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Text(
                                      user.full_name,
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // Text(
                                    //   "Software Engineer",
                                    //   style: TextStyle(
                                    //       fontSize: 20,
                                    //       fontWeight: FontWeight.w500,
                                    //       color: Color(0xffbbbbbb)),
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/PersonalSettingPage");
                                },
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff2177ee),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff2177ee)
                                                    .withOpacity(.4),
                                                blurRadius: 5.0,
                                                offset: Offset(0, 10),
                                                // shadow direction: bottom right
                                              )
                                            ]),
                                        width: 200,
                                        height: 38,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.manage_accounts,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              "Sửa thông tin cá nhân",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            // Icon(
                                            //   Icons.person_add_rounded,
                                            //   color: Colors.white,
                                            // ),
                                            // SizedBox(
                                            //   width: 3,
                                            // ),
                                            // Text(
                                            //   "Theo dõi",
                                            //   style:
                                            //       TextStyle(color: Colors.white),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(18),
                                width: MediaQuery.of(context).size.width,
                                color: Color(0xffeff0f2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 3, bottom: 3),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_city,
                                            color: Color(0xff80889b),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            user.location,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 3, bottom: 3),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Image.asset(
                                            "assets/insta_logo.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            user.work_at,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.pushNamed(context, '/SocialAddPostPage');
                  }),
                  child: PostAdd(
                    ava: user.avatar_url,
                  ),
                ),
                listPosts == null
                    ? Center(child: Text('Không có dữ liệu'))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:
                            listPosts.length != null ? listPosts.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          User userP = listPosts[index].user;
                          var img = <String>[];
                          listPosts[index].posts_imgs.forEach((i) {
                            img.add(API_URL.getImage + i.name.toString());
                          });
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/SocialPostDetail',
                                      arguments: listPosts[index])
                                  .then((value) {
                                if (value) {
                                  _onRefresh();
                                }
                              });
                            },
                            child: PostItem(
                              user: userP,
                              name: userP.full_name,
                              content: listPosts[index].content,
                              imageUrls: img,
                              like: listPosts[index].likes.length.toString(),
                              cmt: listPosts[index].comments.length.toString(),
                            ),
                          );
                        }),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class Friend extends StatelessWidget {
  final String userAsset;
  final String firstName;
  final String lastName;
  const Friend({
    @required this.userAsset,
    @required this.firstName,
    @required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 90,
        height: 165,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Positioned(
                left: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.asset(
                    userAsset,
                    width: 90,
                    height: 102,
                    fit: BoxFit.cover,
                  ),
                )),
            Positioned(
              left: 0,
              top: 110,
              child: Container(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      firstName,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(lastName,
                        style: TextStyle(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
