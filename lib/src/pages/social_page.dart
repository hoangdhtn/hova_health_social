import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/config/api_url.dart';
import 'package:health_app/src/model/post_model.dart';
import 'package:health_app/src/providers/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/post_add.dart';
import '../widgets/post_item.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
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
        getPostList();
      });
    }
    super.initState();
  }

  getPostList() async {
    var fetchedPost = await Provider.of<PostProvider>(context, listen: false)
        .getPosts(position, pageSize);
    setState(() {
      listPosts = fetchedPost["listPost"];
    });
    print("Medical list view : " + listPosts.toString());
  }

  void _loadmore() async {
    var fetchedPost = await Provider.of<PostProvider>(context, listen: false)
        .getPosts(position + 5, pageSize + 5) as List<Post>;
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
          .getPosts(0, 5);
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
          .getPosts(position + 5, pageSize + 5);
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

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFE8E8E8),
          child: listPosts == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                itemCount: listPosts.length != null
                                    ? listPosts.length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  User userP = listPosts[index].user;
                                  var img = <String>[];
                                  listPosts[index].posts_imgs.forEach((i) {
                                    img.add(
                                        API_URL.getImage + i.name.toString());
                                  });
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                              context, '/SocialPostDetail',
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
                                      like: listPosts[index]
                                          .likes
                                          .length
                                          .toString(),
                                      cmt: listPosts[index]
                                          .comments
                                          .length
                                          .toString(),
                                    ),
                                  );
                                }),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}


// return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           color: Color(0xFFE8E8E8),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                       onTap: (() {
//                         print("cccc");
//                         Navigator.pushNamed(context, '/SocialAddPostPage');
//                       }),
//                       child: PostAdd(
//                         ava: user.avatar_url,
//                       )),
//                   PostItem(
//                       user: user,
//                       name: "ccc",
//                       content: "ccccc",
//                       imageUrls: urls,
//                       like: "40",
//                       cmt: "41"),
//                   PostItem(
//                       user: user,
//                       name: "ccc",
//                       content: "ccccc",
//                       imageUrls: urls,
//                       like: "40",
//                       cmt: "41"),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );