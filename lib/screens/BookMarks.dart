import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Adaptors/hive_adp.dart';
import 'package:news_project/provider/Bookmarkprovider.dart';
import 'package:news_project/provider/news_provider.dart';
import 'package:news_project/services/dbService.dart';
import 'package:provider/provider.dart';

class BookMarks extends StatefulWidget {
  const BookMarks({super.key});

  @override
  State<BookMarks> createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NewsProvider>(context, listen: false);
  }

  Key key = Key("5");
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(builder: (context, value, child) {
      final res = value.news;
      print(res.news);

      return Consumer<BookmarkProvider>(builder: (context, value, child) {
        final _bm = value.getlist();

        final w = MediaQuery.sizeOf(context).width;
        final h = MediaQuery.sizeOf(context).height;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Bookmarks',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 2,
          ),
          body: Container(
            height: h * 0.9,
            child: _bm.length == 0
                ? Center(
                    child: Text(
                      "BooksMarks is Empty",
                      style:
                          GoogleFonts.poppins(fontSize: 28, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _bm.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print('object');
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: w * 0.1),
                                  child: Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.red.shade100,
                              Colors.white,
                            ])),
                          ),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            print(_bm[index].id);
                            setState(() {
                              value.deleteFromBookmark(_bm[index].id);
                            });

                            // value.notifyListeners();
                          },
                          child: Card(
                            elevation: 10,
                            child: Column(
                              children: [
                                Container(
                                    height: h * 0.15,
                                    color: Colors.grey.shade200,
                                    margin: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: w * 0.6,
                                            child: Text(
                                              _bm[index].title.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(),
                                            )),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black)),
                                          height: h * 0.5,
                                          width: w * 0.25,
                                          child: CachedNetworkImage(
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                              placeholder: (context, url) =>
                                                  const SpinKitCircle(
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  _bm[index].image.toString()),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        );
      });
    });
  }
}
