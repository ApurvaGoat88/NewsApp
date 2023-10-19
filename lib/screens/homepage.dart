import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_project/adapter/hive_adp.dart';
import 'package:news_project/provider/news_provider.dart';
import 'package:news_project/screens/new_screen.dart';
import 'package:news_project/utils/list_env.dart';
import 'package:news_project/utils/listview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NewsProvider>(context, listen: false).get_news(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          leading:
              IconButton(onPressed: () {}, icon: const Icon(Icons.category)),
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                Text('Delhi,India')
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.person))
          ],
        ),
        body: const Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _controller = TextEditingController();
  String cate = 'India';
  final List<String> _cate = [
    'India',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Science & Tech'
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Consumer<NewsProvider>(builder: (context, value, child) {
      final boomlist = value.hivelist;

      final res = value.news;
      return Scaffold(
        appBar: AppBar(
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
                height: h * 0.08,
                width: w,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
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
                            height: h * 0.1,
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
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              value.isLoading
                  ? SizedBox(
                      height: h * 0.5,
                      child: const Center(
                        child: SpinKitDualRing(color: Colors.orange),
                      ),
                    )
                  : SizedBox(
                      height: h * 0.5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: res.number,
                        itemBuilder: (context, index) {
                          final _news = res.news![index];
                          return InkWell(
                            onTap: () {
                              Get.to(NewsScreen(
                                index: index,
                              ));
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
                                              borderRadius:
                                                  BorderRadius.circular(23),
                                              child: Container(
                                                  constraints:
                                                      const BoxConstraints
                                                          .expand(),
                                                  child: Expanded(
                                                    child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            const SpinKitFoldingCube(
                                                              color:
                                                                  Colors.orange,
                                                              size: 20,
                                                            ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                              Icons
                                                                  .error_outline_outlined,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                        imageUrl: _news.image
                                                            .toString()),
                                                  ))),
                                        ),
                                        Positioned(
                                          bottom: h * 0.01,
                                          child: Container(
                                            height: h * 0.18,
                                            width: w * 0.9,
                                            child: Opacity(
                                              opacity: 0.8,
                                              child: Card(
                                                color: Colors.grey.shade300,
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
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      value.fav[_news
                                                                          .title
                                                                          .toString()] = 1;
                                                                    },
                                                                    icon: Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: value.fav[_news.title.toString()] !=
                                                                                null
                                                                            ? Colors.red
                                                                            : Colors.black)),
                                                                value.fav[_news
                                                                            .title
                                                                            .toString()] ==
                                                                        null
                                                                    ? const Text(
                                                                        '0')
                                                                    : Text(
                                                                        '${value.fav[_news.title.toString()]}'),
                                                              ],
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                print(value
                                                                    .hivelist
                                                                    .length);
                                                                value.add_list(
                                                                    _news);
                                                                HiveModel m =
                                                                    HiveModel(
                                                                        news:
                                                                            _news,
                                                                        id: _news
                                                                            .id!);

                                                                value
                                                                    .addTask(_news.id,m);
                                                              },
                                                              icon: const Icon(Icons
                                                                  .bookmark_add_rounded),
                                                              color: (value.bookmark[
                                                                              _news] ==
                                                                          true &&
                                                                      value.list.contains(
                                                                              _news) ==
                                                                          true)
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .black)
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                color: Color.fromARGB(255, 255, 253, 253),
                height: h * 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: w * 0.02),
                          child: Text(
                            'Recommendation...',
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Container(
                              margin: EdgeInsets.only(right: w * 0.02),
                              child: Text(
                                'See All',
                                style: GoogleFonts.poppins(
                                    color: Colors.blue, fontSize: 15),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      child: Text(
                        'Politics',
                        style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    ListView22(),
                    Container(
                      child: Text(
                        'Environment',
                        style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    ListView33(),
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
