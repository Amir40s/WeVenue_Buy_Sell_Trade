import 'package:biouwa/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoaderWidget extends StatelessWidget {
  final String imageUrl;
  final double? radius;

  const ImageLoaderWidget({super.key, required this.imageUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty || imageUrl == ''
        ? CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage("assets/icons/ic_profile_image.webp"),
          )
        : CachedNetworkImage(
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
