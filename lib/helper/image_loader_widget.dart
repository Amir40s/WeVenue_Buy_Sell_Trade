import 'package:biouwa/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoaderWidget extends StatelessWidget {
  final String imageUrl;

  const ImageLoaderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(
        color: primaryColor,
      ),
      errorWidget: (context, url, error) =>
          Image.asset("assets/icons/ic_profile_image.webp"),
      fit: BoxFit.cover,
    );
  }
}
