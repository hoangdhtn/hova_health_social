import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/widgets/post_image.dart';

class PostItem extends StatefulWidget {
  const PostItem({Key key}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

var urls = <String>[
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
];

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(140),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(140)),
                    height: 58,
                    width: 60,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            height: 78,
                            width: 74,
                            margin: const EdgeInsets.only(
                                left: 0.0, right: 0, top: 0, bottom: 0),
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(140)),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://storage.googleapis.com/multibhashi-website/website-media/2017/12/person.jpg',
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 13),
                      child: Text(
                        'Sound Byte',
                        style: GoogleFonts.lato(
                            color: Colors.grey[700],
                            fontSize: 16,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 13),
                      child: Text(
                        'is now connected',
                        style: GoogleFonts.lato(
                            color: Colors.grey[700],
                            fontSize: 16,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Image.network(
                  'https://static.thenounproject.com/png/658625-200.png',
                  height: 30,
                ),
              ),
            ],
          ),
          Container(
            height: 278,
            child: PhotoGrid(
              imageUrls: urls,
              onImageClicked: (i) => print('Image $i was clicked!'),
              onExpandClicked: () => print('Expand Image was clicked'),
              maxImages: 4,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 28.0, bottom: 15),
                child: Row(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.favorite_border_outlined,
                        color: Color.fromARGB(255, 63, 62, 62),
                        size: 30.0,
                      ),
                    ),
                    Text(
                      '45',
                      style: GoogleFonts.averageSans(
                          color: Colors.grey[700],
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 28.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 1.0),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Color.fromARGB(255, 63, 62, 62),
                        size: 30.0,
                      ),
                    ),
                    Text(
                      '45',
                      style: GoogleFonts.averageSans(
                          color: Colors.grey[700],
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
