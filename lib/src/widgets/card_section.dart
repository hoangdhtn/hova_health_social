import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/const.dart';
import 'custom_clipper.dart';

class CardSection extends StatefulWidget {
  final String title;
  final String value;
  final String unit;
  final String time;
  final ImageProvider image;
  final bool isDone;
  final Function onPressed;

  CardSection(
      {Key key,
      @required this.title,
      @required this.value,
      @required this.unit,
      @required this.time,
      @required this.image,
      @required this.onPressed,
      this.isDone})
      : super(key: key);

  @override
  State<CardSection> createState() => _CardSectionState();
}

class _CardSectionState extends State<CardSection> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: 240,
        height: 150,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Positioned(
              child: ClipPath(
                clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Constants.lightBlue.withOpacity(0.1),
                  ),
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image(
                        image: widget.image,
                        width: 24,
                        height: 24,
                        color: Theme.of(context).accentColor,
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(
                            fontSize: 15, color: Constants.textPrimary),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.textPrimary),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.value} ${widget.unit}',
                              style: TextStyle(
                                  fontSize: 15, color: Constants.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            shape: BoxShape.rectangle,
                            color: widget.isDone
                                ? Theme.of(context).accentColor
                                : Color(0xFFF0F4F8),
                          ),
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: widget.isDone
                                  ? Colors.white
                                  : Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          widget.onPressed();
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
