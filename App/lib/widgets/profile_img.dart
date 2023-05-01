import 'package:flutter/material.dart';

class Userprofile extends StatelessWidget {
  final ImageProvider imageProvider;
  final String text1;
  final String text2;
  final String? text3;
  final double height;
  final double width;
  final TextStyle? textStyle;

  const Userprofile({
    required this.imageProvider,
    required this.text1,
    required this.text2,
    this.text3,
    required this.height,
    required this.width,
    this.textStyle,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.2),
          borderRadius: BorderRadius.circular(15)
      ),
      height: height,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: imageProvider),
          Text(text1,style: textStyle),
          Text(text2,style: textStyle),
          Text(text3 ?? '',style: textStyle)

        ],
      ),
    );
  }
}
