import 'package:biouwa/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'images.dart';
class ImageLoaderWidget extends StatelessWidget {
  final String imageUrl;
  const ImageLoaderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(color: primaryColor,), // Path to your placeholder image
      errorWidget: (context, url, error) => Image.asset("assets/icons/ic_profile_image.webp"), // Display an error icon if the image fails to load
      fit: BoxFit.cover,
    );
  }
}
