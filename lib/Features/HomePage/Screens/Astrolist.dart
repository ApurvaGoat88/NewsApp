import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Features/HomePage/Provider/env_news.dart';
import 'package:news_project/Features/News%20Page/Screens/AstroScreen.dart';
import 'package:news_project/Features/News%20Page/Screens/Enviroment_newsScreen.dart';
import 'package:provider/provider.dart';

class ListView4 extends StatefulWidget {
  const ListView4({super.key});

  @override
  State<ListView4> createState() => _ListView4State();
}

class _ListView4State extends State<ListView4> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AstroProvider>(context, listen: false).get_list('Astrology');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Consumer<AstroProvider>(builder: (context, value, child) {
      final res = value.news;

      return value.isLoading
          ? Center(
              child: Container(
              height: h * 0.14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Getting Latest News',
                    style: GoogleFonts.ubuntu(),
                  ),
                  SizedBox(width: w * 0.04),
                  const SpinKitWanderingCubes(
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            ))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.02),
              child: Center(
                child: Container(
                  height: h * 01.8,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: res.number,
                      physics: NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (cotext, index) {
                        final _news = res.news![index];
                        return InkWell(
                          onTap: () {
                            Get.to(NewsScreenofAstro(index: index));
                          },
                          child: Center(
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Container(
                                      height: h * 0.15,
                                      color: Colors.grey.shade200,
                                      margin: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: w * 0.5,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(w * .05),
                                                child: Text(
                                                  _news.title.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              )),
                                          Container(
                                            height: h * 0.5,
                                            width: w * 0.25,
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const SpinKitFoldingCube(
                                                      color: Colors.orange,
                                                      size: 20,
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                          Icons
                                                              .error_outline_outlined,
                                                          color: Colors.orange,
                                                        ),
                                                imageUrl:
                                                    _news.image.toString()),
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
              ),
            );
    });
  }
}
