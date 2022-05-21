import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/pages/medical_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../config/api_url.dart';
import '../model/medical_model.dart';
import '../model/user_model.dart';
import '../providers/medical_provider.dart';
import '../providers/user_provider.dart';
import '../theme/const.dart';
import '../widgets/card_items.dart';
import '../widgets/custom_clipper.dart';

class MedicalAllPage extends StatefulWidget {
  const MedicalAllPage({Key key}) : super(key: key);

  @override
  State<MedicalAllPage> createState() => _MedicalAllPageState();
}

class _MedicalAllPageState extends State<MedicalAllPage> {
  List<Medical> listMedical = [];
  int pageSize = 5;
  int position = 0;

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getMedicalList();
      });
    }
    super.initState();
  }

  getMedicalList() async {
    var fetchedMedical =
        await Provider.of<MedicalProvider>(context, listen: false)
            .getMedical(position, pageSize) as List<Medical>;
    setState(() {
      listMedical = fetchedMedical;
    });
    print("Medical list view : " + listMedical.toString());
  }

  void _loadmore() async {
    var fetchedMedical =
        await Provider.of<MedicalProvider>(context, listen: false)
            .getMedical(position + 5, pageSize + 5) as List<Medical>;
    if (fetchedMedical != null &&
        fetchedMedical.isNotEmpty &&
        fetchedMedical.length > 0) {
      setState(() {
        listMedical.addAll(fetchedMedical);
        position += 5;
        pageSize += 5;
      });
    }
  }

  DateTime stringToDate(String date) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
    return tempDate;
  }

  int dateBetween(DateTime from, DateTime to) {
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget _appbar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BackButton(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;

    void _onRefresh() async {
      // monitor network fetch
      var fetchedMedical =
          await Provider.of<MedicalProvider>(context, listen: false)
              .getMedical(0, 5) as List<Medical>;
      setState(() {
        listMedical = fetchedMedical;
        position = 0;
        pageSize = 5;
      });
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }

    void _onLoading() async {
      var fetchedMedical =
          await Provider.of<MedicalProvider>(context, listen: false)
              .getMedical(position + 5, pageSize + 5) as List<Medical>;
      if (fetchedMedical != null &&
          fetchedMedical.isNotEmpty &&
          fetchedMedical.length > 0) {
        setState(() {
          listMedical.addAll(fetchedMedical);
          position += 5;
          pageSize += 5;
        });
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }

    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
              Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(clipType: ClipType.bottom),
                    child: Container(
                      color: Theme.of(context).accentColor,
                      height: Constants.headerHeight + statusBarHeight - 30,
                    ),
                  ),
                  Positioned(
                    right: -45,
                    top: -30,
                    child: ClipOval(
                      child: Container(
                        color: Colors.black.withOpacity(0.05),
                        height: 220,
                        width: 220,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Constants.paddingSide),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                                size: 36.0,
                              ),
                            )
                          ],
                        ),
                        // Header - Greetings and Avatar
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Lịch sử bệnh của,\n${user.full_name}",
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                            CircleAvatar(
                                radius: 26.0,
                                backgroundImage: user.avatar_url == null
                                    ? const AssetImage(
                                        'assets/icons/profile_picture.png')
                                    : NetworkImage(
                                        API_URL.getImage + user.avatar_url))
                          ],
                        ),

                        // Main Cards - Heartbeat and Blood Pressure

                        // Info Medical
                        SizedBox(height: 70),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                  color: Constants.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/MedicalAddPage')
                                    .then((value) {
                                  if (value) {
                                    _onRefresh();
                                  }
                                });
                              },
                              child: const Text(
                                "THÊM",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: listMedical == null
                    ? Center(child: Text('Không có dữ liệu'))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:
                            listMedical.length != null ? listMedical.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/MedicalDetailPage",
                                arguments: listMedical[index],
                              ).then((value) {
                                if (value) {
                                  _onRefresh();
                                }
                              });
                            },
                            child: CardItems(
                              image: Image.asset(
                                'assets/icons/history_medical.png',
                              ),
                              title: listMedical[index].name,
                              value: "Thời gian bị",
                              unit: listMedical[index].created_at != null &&
                                      listMedical[index].updated_at != null
                                  ? dateBetween(
                                              stringToDate(listMedical[index]
                                                  .created_at),
                                              stringToDate(listMedical[index]
                                                  .updated_at))
                                          .toString() +
                                      " ngày"
                                  : "",
                              color: Constants.lightYellow,
                              progress: 100,
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
