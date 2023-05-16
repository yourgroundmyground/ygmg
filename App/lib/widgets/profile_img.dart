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
    final mediaWidth = MediaQuery.of(context).size.width;

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
          SizedBox(width: mediaWidth*0.02),
          SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(image: imageProvider,
                  fit: BoxFit.cover))),
          SizedBox(width: mediaWidth*0.02),
          SizedBox(
            width: mediaWidth*0.07,
              child: Text(text1,style: textStyle)),
          SizedBox(
              width: mediaWidth*0.3,
              child: Text(text2, style: textStyle)),
          SizedBox(
              width: mediaWidth*0.2,
              child: Text(text3 ?? '',style: textStyle))
        ],
      ),
    );
  }
}
