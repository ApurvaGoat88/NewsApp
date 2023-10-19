import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/provider/list_provider.dart';
import 'package:provider/provider.dart';

class ListView22 extends StatefulWidget {
  const ListView22({super.key});
  

  @override
  State<ListView22> createState() => _ListView22State();
}

class _ListView22State extends State<ListView22> {

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ListProvider>(context, listen: false).get_list('political');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Consumer<ListProvider>(builder: (context, value, child) {
      final res = value.news;

      return value.isLoading
          ? Center(
              child: Container(
              height: h * 0.14,
              child:const  SpinKitDualRing(
                color: Colors.orange,
                size: 20,
              ),
            ))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.02),
              child: Center(
                child: Container(
                  height: h * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: res.number,
                      itemBuilder: (cotext, index) {
                        final _news = res.news![index];
                        return Center(
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
                                              imageUrl: _news.image.toString()),
                                        )
                                      ],
                                    )),
                              ],
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
