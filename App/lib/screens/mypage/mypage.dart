import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/bottomnavbar.dart';

class Mypage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('마이페이지')),
      body: Text('내용'),
      // bottomNavigationBar: HomePage(),
    );
  }
}