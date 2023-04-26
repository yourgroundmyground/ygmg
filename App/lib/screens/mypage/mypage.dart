import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/bottomnavbar.dart';

class Mypage extends StatelessWidget {
  const Mypage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
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
              image : AssetImage('assets/images/mypage-bg.png'),
              fit : BoxFit.fitWidth,
              alignment: Alignment.topLeft,
              repeat: ImageRepeat.noRepeat
            )
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                  width: double.infinity,
                    height: mediaWidth*0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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

                  ),
                  Positioned(
                    child: Container(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '안녕하세요, ${nickname} 님!',
                            style: TextStyle(
                                fontSize: mediaWidth*0.04,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(255, 255, 255, 1)
                            ),
                          )),
                    ),
                  ),
                  Positioned(
                    left: mediaWidth*0.05,
                      child: Container(
                        width: mediaWidth*0.2,
                        height: mediaWidth*0.2,
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
                      child: Image.asset('assets/images/testProfile.png'),
                  )),
                  Positioned(
                    right: mediaWidth*0.05,
                      child: Container(
                        child: Image.asset('assets/images/Gear.png'),
                  ))
                ],
              ),
              Container(
                width: mediaWidth*0.9,
                height: mediaWidth*0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(mediaWidth*0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // spreadRadius: 7,
                      blurRadius: 28,
                      // offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(23, 19, 23, 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('주간 결과', style: TextStyle(
                          fontSize: mediaWidth*0.04,
                          fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
      // bottomNavigationBar: HomePage(),
    );
  }
}