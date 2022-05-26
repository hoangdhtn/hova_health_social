import 'package:flutter/material.dart';
import 'package:health_app/src/config/api_url.dart';
import 'package:health_app/src/model/doctor_model.dart';
import 'package:health_app/src/theme/light_color.dart';
import 'package:intl/intl.dart';

class DoctorDetailPage extends StatefulWidget {
  const DoctorDetailPage({Key key}) : super(key: key);

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Data param
    Doctor doctorParam = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              'Thông tin bác sĩ',
            ),
            backgroundColor: Color(LightColor.primary),
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/hospital.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(
              name: doctorParam.name,
              department: doctorParam.departments.name,
              img: doctorParam.ava_url,
              info: doctorParam.description,
              price: doctorParam.price.toString(),
              duration: doctorParam.duration.toString(),
              rating: doctorParam.rating.toString(),
              onTap: () {
                Navigator.pushNamed(context, "/BookingPage",
                    arguments: doctorParam);
              },
            ),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  String name;
  String department;
  String img;
  String info;
  String price;
  String duration;
  String rating;
  final void Function() onTap;

  DetailBody(
      {Key key,
      this.name,
      this.department,
      this.img,
      this.info,
      this.onTap,
      this.duration,
      this.price,
      this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailDoctorCard(
            name: name,
            department: department,
            img: img,
          ),
          SizedBox(
            height: 15,
          ),
          DoctorInfo(
            price: price,
            duration: duration,
            rating: rating,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Thông tin về tôi',
            style: kTitleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            info,
            style: TextStyle(
              color: Color(LightColor.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(LightColor.primary),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Text(
                      'Đặt lịch hẹn',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  String price;
  String duration;
  String rating;
  DoctorInfo({Key key, this.price, this.duration, this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NumberCard(
          label: 'Chi phí',
          value: NumberFormat.simpleCurrency(locale: 'vi', decimalDigits: 0)
              .format(int.parse(price))
              .toString(),
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Thời gian',
          value: '${duration} phút',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Đánh giá',
          value: '${rating}.0',
        ),
      ],
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String title;
  final String desc;
  const AboutDoctor({
    Key key,
    this.title,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NumberCard extends StatelessWidget {
  String label;
  String value;

  NumberCard({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(LightColor.bg03),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(LightColor.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(LightColor.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  String name;
  String department;
  String img;
  DetailDoctorCard({
    this.name,
    this.department,
    this.img,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BS. ' + name,
                      style: TextStyle(
                        color: Color(LightColor.header01),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      department,
                      style: TextStyle(
                        color: Color(LightColor.grey02),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Image(
                image: img == null || img == ""
                    ? AssetImage('assets/doctor_user.png')
                    : NetworkImage(API_URL.getImage + img),
                width: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle kTitleStyle = TextStyle(
  color: Color(LightColor.header01),
  fontWeight: FontWeight.bold,
);

TextStyle kFilterStyle = TextStyle(
  color: Color(LightColor.bg02),
  fontWeight: FontWeight.w500,
);
