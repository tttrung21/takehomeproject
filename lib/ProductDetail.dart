import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:takehomeproject/ProductItem.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, this.item});

  final ProductItem? item;

  String replaceLastSpace(String? str) {
    if (str!.endsWith(' ')) {
      return str.substring(0, str.length - 1);
    }
    return str;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        leadingWidth: 0,
        toolbarHeight: 96,
        leading: const SizedBox(),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.chevron_left,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '${replaceLastSpace(item?.name)} ${item?.headline}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: item?.id ?? '',
              child: CachedNetworkImage(
                imageUrl: item?.image ?? '',
                fit: BoxFit.cover,
                // height: 180,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 260,
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
            if (item?.description?.isNotEmpty ?? false) buildText('Description', item?.description),
            if (item?.description?.isNotEmpty ?? false)
              const SizedBox(
                height: 8,
              ),
            if (item?.difficulty != null ) buildText('Meal complexity', item?.difficulty.toString()),
            if (item?.difficulty != null)
              const SizedBox(
                height: 8,
              ),
            if (item?.calories?.isNotEmpty ?? false) buildText('Calories for this meal', item?.calories),
            if (item?.calories?.isNotEmpty ?? false)
              const SizedBox(
                height: 8,
              ),
            if (item?.carbos?.isNotEmpty ?? false) buildText('Carbs', item?.carbos),
            if (item?.carbos?.isNotEmpty ?? false)
              const SizedBox(
                height: 8,
              ),

            if (item?.fats?.isNotEmpty ?? false) buildText('Fats', item?.fats),
            if (item?.fats?.isNotEmpty ?? false)
              const SizedBox(
                height: 8,
              ),
            if (item?.proteins?.isNotEmpty ?? false) buildText('Proteins', item?.proteins),
            if (item?.proteins?.isNotEmpty ?? false)
              const SizedBox(
                height: 8,
              ),

            if (item?.time?.isNotEmpty ?? false) buildText('Time to make', parseISODuration(item?.time ?? '')),

          ],
        ),
      ),
    );
  }

  Widget buildText(String? title, String? data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
            text: '$title: ',
            style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                  text: data,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black, wordSpacing: 0.5))
            ]),
      ),
    );
  }
}
