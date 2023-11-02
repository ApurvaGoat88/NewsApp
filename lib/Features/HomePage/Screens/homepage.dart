import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:news_project/Features/Boomarks/Providers/Bookmarkprovider.dart';
import 'package:news_project/Features/Comments/Widget/commentlist.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';
import 'package:news_project/Features/News%20Page/Screens/new_screen.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';
import 'package:news_project/Features/Boomarks/Services/dbService.dart';
import 'package:news_project/Features/HomePage/Screens/list_env.dart';
import 'package:news_project/Features/HomePage/Screens/listview.dart';
import 'package:news_project/model/CommentsModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  late final AnimationController _cont;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  bool _value = false;
  bool theme = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cont = AnimationController(vsync: this);
  }

  final _comment = TextEditingController();
  String cate = 'India';
  final List<String> _cate = [
    'India',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Science & Tech'
  ];

  void addComment(int? id, String comments, user) async {
    getComments(id).then((value) {
      print(value);
      value.add({'comment': comments, 'user': user});
      print(value);
      CommentsModel commentsModel = CommentsModel(comments: value);
      FirebaseFirestore.instance
          .collection('Comments')
          .doc(id.toString())
          .set({'comments': value}).then((value) =>
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Comment added, Please refreash'))));

      print('done');
    });
  }

  void addCommentifNULL(int? id, String comments, user) async {
    FirebaseFirestore.instance.collection('Comments').doc(id.toString()).set({
      'comments': [
        {'comment': comments, 'user': user}
      ]
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added, Please refreash'))));
  }

  Future<bool> doesDocumentExist(int? id) async {
    String collectionName = 'Comments';
    String documentId = id.toString();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    return documentSnapshot.exists;
  }

  Future<List<dynamic>> getComments(int? id) async {
    final collection = await FirebaseFirestore.instance
        .collection('Comments')
        .doc(id.toString())
        .get();
    final commentlist = collection.get('comments') as List<dynamic>;

    return commentlist;
  }

  void _showSheet(h, w, int? id) {
    doesDocumentExist(id).then((value) {
      print(value);
      if (value) {
        final collection =
            FirebaseFirestore.instance.collection('Comments').get();

        getComments(id).then((value) {
          showBottomSheet(
            elevation: 20,
            context: context,
            builder: (context) {
              print(value.length);
              return Container(
                height: h * 0.6,
                width: w,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: h * .01),
                      child: Container(
                        width: w * 0.08,
                        height: h * 0.008,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(23)),
                      ),
                    ),
                    Text(
                      'Comments',
                      style: GoogleFonts.ubuntu(fontSize: h * 0.03),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Container(
                        // color: Colors.red,
                        height: h * 0.42,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(23)),
                                width: w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.05,
                                      vertical: h * 0.004),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            value[index]['user'].toString(),
                                            style: GoogleFonts.ubuntu(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: w,
                                        alignment: Alignment.centerLeft,
                                        child: Expanded(
                                          child: Text(
                                            value[index]['comment'].toString(),
                                            style: GoogleFonts.ubuntu(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    const Divider(
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.01),
                      child: TextField(
                        controller: _comment,
                        decoration: InputDecoration(
                            suffixIconColor: Colors.black,
                            hintText: 'Type your opinion',
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23)),
                            suffixIcon: IconButton(
                                onPressed: () => addComment(id, _comment.text,
                                    user!.displayName.toString()),
                                icon: Icon(Icons.send_rounded))),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
      } else {
        showBottomSheet(
          elevation: 20,
          context: context,
          builder: (context) {
            return Container(
                height: h * 0.6,
                width: w,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: h * .01),
                    child: Container(
                      width: w * 0.08,
                      height: h * 0.008,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(23)),
                    ),
                  ),
                  Text(
                    'Comments',
                    style: GoogleFonts.ubuntu(fontSize: h * 0.03),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Container(
                      // color: Colors.red,
                      height: h * 0.42,
                      child: Center(
                        child: Text(
                          "Become First to add comment ",
                          style: GoogleFonts.ubuntu(fontSize: 20),
                        ),
                      )),
                  const Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.01),
                    child: TextField(
                      controller: _comment,
                      decoration: InputDecoration(
                          suffixIconColor: Colors.black,
                          hintText: 'Type your opinion',
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(23)),
                          suffixIcon: IconButton(
                              onPressed: () => addCommentifNULL(id,
                                  _comment.text, user!.displayName.toString()),
                              icon: Icon(Icons.send_rounded))),
                    ),
                  )
                ]));
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Consumer<NewsProvider>(builder: (context, value, child) {
      final res = value.news;

      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 10,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade600,
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.category_sharp)),
          title: Text(
            'News ToDay',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34)),
                        prefixIcon: const Icon(Icons.search_sharp),
                        iconColor: Colors.black,
                        prefixIconColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34)),
                        hintText: 'Find Interesting News',
                        suffixIcon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(34))),
                                onPressed: () {
                                  if (_controller.text
                                          .toString()
                                          .trim()
                                          .length !=
                                      0) {
                                    value.bookmark.clear();
                                    value.get_news(_controller.text.toString());
                                  } else {
                                    return null;
                                  }
                                },
                                child: Text(
                                  'Search',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                )))),
                  ),
                ),
              ),
              Container(
                height: h * 0.1,
                width: w,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _cate.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            cate = _cate[index];
                            value.get_news(cate);

                            setState(() {});
                          },
                          child: Container(
                            height: h * 0.15,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: cate == _cate[index]
                                    ? Colors.orange.shade400
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(23)),
                            child: Text(
                              _cate[index].toString(),
                              style: GoogleFonts.ubuntu(
                                  fontSize: h * 0.018,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              if (value.isLoading)
                SizedBox(
                  height: h * 0.5,
                  child: const Center(
                    child: SpinKitWanderingCubes(color: Colors.black),
                  ),
                )
              else
                SizedBox(
                    height: h * 0.5,
                    child: CarouselSlider(
                      options: CarouselOptions(
                          autoPlayInterval: Duration(seconds: 3),
                          height: h * 0.5,
                          viewportFraction: 1,
                          autoPlay: true),
                      items: List.generate(res.number!, (index) {
                        final _news = res.news![index];
                        return InkWell(
                          onTap: () {
                            Get.to(NewsScreen(index: index));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: w * 1,
                                      height: h * 0.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(23),
                                        child: Container(
                                          constraints:
                                              const BoxConstraints.expand(),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const SpinKitWanderingCubes(
                                              color: Colors.black,
                                              size: 40,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error_outline_outlined,
                                              color: Colors.orange,
                                            ),
                                            imageUrl: _news.image.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: h * 0.01,
                                      child: Container(
                                        height: h * 0.18,
                                        width: w * 0.9,
                                        child: Opacity(
                                          opacity: 0.8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 4,
                                                      offset: Offset(0, 0.5))
                                                ],
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(23)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _news.title.toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Consumer<BookmarkProvider>(
                                                      builder: (context, value2,
                                                          child) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () =>
                                                                  _showSheet(
                                                                      h,
                                                                      w,
                                                                      _news.id),
                                                              icon: const Icon(
                                                                  Icons
                                                                      .comment),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                value2
                                                                    .add_bookmark(
                                                                        _news);
                                                                setState(() {});
                                                              },
                                                              icon: value2.box
                                                                      .containsKey(
                                                                          _news
                                                                              .id)
                                                                  ? const Icon(
                                                                      Icons
                                                                          .bookmark_added_rounded,
                                                                      color: Colors
                                                                          .orange,
                                                                      size: 25,
                                                                    )
                                                                  : const Icon(Icons
                                                                      .bookmark_add_outlined),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                color: const Color.fromARGB(255, 255, 253, 253),
                height: h * 6,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: w * 0.02),
                          child: Text(
                            'Recommendations ',
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(right: w * 0.02),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w * 0.03),
                                child: Text(
                                  'See All',
                                  style: GoogleFonts.poppins(
                                      color: Colors.blue, fontSize: 15),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      child: Text(
                        'Politics',
                        style: GoogleFonts.kanit(
                            color: const Color.fromARGB(255, 45, 42, 42),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    const ListView22(),
                    Container(
                      child: Text(
                        'Environment',
                        style: GoogleFonts.kanit(
                            color: const Color.fromARGB(255, 23, 21, 21),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    const ListView33(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
