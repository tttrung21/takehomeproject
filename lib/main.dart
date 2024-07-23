import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:takehomeproject/ProductDetail.dart';
import 'package:takehomeproject/ProductItem.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const MyHomePage(title: 'Take Home Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProductItem>? listProduct = [];
  bool isFirstLoad = true;

  Future fetchApi() async {
    final url = Uri.parse('https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json');
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body);
      for (final data in extractedData) {
        listProduct?.add(ProductItem.fromJson(data));
      }
    } catch (e) {
      BotToast.showSimpleNotification(
          title: 'Error fetching data',
          titleStyle: const TextStyle(color: CupertinoColors.white),
          duration: const Duration(seconds: 2),
          align: Alignment.bottomCenter,
          backgroundColor: Colors.red);
    }
    isFirstLoad = false;
    setState(() {});
  }

  String parseISODuration(String isoString) {
    String timePart = isoString.replaceFirst('PT', '');

    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    String time = '';

    RegExp exp = RegExp(r'(\d+H)?(\d+M)?(\d+S)?');
    RegExpMatch? match = exp.firstMatch(timePart);

    if (match != null) {
      if (match.group(1) != null) {
        hours = int.parse(match.group(1)!.replaceFirst('H', ''));
        time += '${hours}H';
      }
      if (match.group(2) != null) {
        minutes = int.parse(match.group(2)!.replaceFirst('M', ''));
        time += '${minutes}M';
      }
      if (match.group(3) != null) {
        seconds = int.parse(match.group(3)!.replaceFirst('S', ''));
        time += '${seconds}S';
      }
    }
    return time;
  }

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          elevation: 0,
        ),
        body: isFirstLoad
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )
            : listProduct?.isEmpty ?? false
                ? buildEmptyData(title: 'No data found')
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return buildItem(productItem: listProduct?[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                    itemCount: listProduct?.length ?? 0));
  }

  Widget buildItem({ProductItem? productItem}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetail(
                item: productItem,
              ))),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Hero(
                tag: productItem?.id ?? '',
                child: CachedNetworkImage(
                  imageUrl: productItem?.thumb ?? '',
                  fit: BoxFit.cover,
                  // height: 180,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 212,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(
                      Icons.image_not_supported,
                      size: 40,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  productItem?.name ?? '',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(productItem?.headline ?? '',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(parseISODuration(productItem?.time ?? ''), style: const TextStyle(height: 0, fontSize: 16))
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.bar_chart,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(productItem?.difficulty.toString() ?? '', style: const TextStyle(height: 0, fontSize: 16))
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.fastfood,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          productItem?.calories ?? '',
                          style: const TextStyle(height: 0, fontSize: 16),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyData({required String title}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.doc_fill,
            size: 120,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize:32, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
