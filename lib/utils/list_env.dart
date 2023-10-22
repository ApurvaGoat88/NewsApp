import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/provider/env_news.dart';
import 'package:provider/provider.dart';

class ListView33 extends StatefulWidget {
  const ListView33({super.key});

  @override
  State<ListView33> createState() => _ListView33State();
}

class _ListView33State extends State<ListView33> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EnvProvider>(context, listen: false).get_list('Environment');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Consumer<EnvProvider>(builder: (context, value, child) {
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
                  const SpinKitDualRing(
                    color: Colors.orange,
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
                            print(index);
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
                                              child: Text(
                                                _news.title.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: GoogleFonts.poppins(),
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
