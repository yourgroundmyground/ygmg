import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/bottomnavbar.dart';

class Mypage extends StatelessWidget {
  const Mypage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 닉네임
    var nickname = '달려달려';
    return  Scaffold(
      // appBar: AppBar(title: Text('마이페이지')),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image : DecorationImage(
              image : AssetImage('images/mypage-bg.png'),
              fit : BoxFit.fitWidth,
              alignment: Alignment.topLeft,
              repeat: ImageRepeat.noRepeat
            )
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 252, 99, 99),
                        Color.fromRGBO(255, 66, 41, 1.0),
                      ]
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('안녕하세요, ${nickname} 님!'),
              ),
              Container(
                width:  76,
                height: 76,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFBCA92),
                          Color(0xFFEF7EC2)
                        ]
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0,4),
                      )
                    ]
                ),
                child: Image.asset('images/testProfile.png'),      // *프로필 사진 넣어주기
              ),
            ],
          ),
        ),
      )
      // bottomNavigationBar: HomePage(),
    );
  }
}