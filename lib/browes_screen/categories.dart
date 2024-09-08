import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';


class Categories extends StatelessWidget {
  String imageUrl;
  String genreName;
  VoidCallback onTap;

  Categories({
    required this.imageUrl,
    required this.genreName,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              genreName,
              style: TextStyle(
                color: Appcolors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}