import 'package:app/utils/polygonmap.dart';
import 'package:app/widgets/profile_img.dart';
import 'package:flutter/material.dart';

class InGame extends StatelessWidget {
  const InGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          child: PolygonMap(),
        ),
        Positioned(
          left: mediaWidth*0.03,
          top: mediaHeight*0.03,
          child: Container(
            //왼쪽 위 모달
            width: 200,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                Text('시간모달', style: TextStyle(fontSize: 20,color: Colors.black),),
                Text('0m²', style: TextStyle(fontSize: 25,color: Colors.black, fontWeight: FontWeight.w400),)
              ],
            ),
          ),
        ),
        Positioned(
            right: mediaWidth*0.03,
            top: mediaHeight*0.03,
            child: Container(
              //오른쪽 위 모달
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text('실시간 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
                      SizedBox(
                        child: Userprofile(
                            height: mediaHeight*0.04,
                            width: mediaWidth*0.8,
                            imageProvider: AssetImage('assets/images/profile01mini.png'),
                            text1: '1',
                            text2: '군침이싹도나',
                            text3: null,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15
                            )),
                      ),
                      SizedBox(
                        child: Userprofile(
                            height: mediaHeight*0.04,
                            width: mediaWidth*0.8,
                            imageProvider: AssetImage('assets/images/profile02mini.png'),
                            text1: '2',
                            text2: '오늘도군것질',
                            text3: null,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15
                            )),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text('내 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
                      SizedBox(
                        child: Userprofile(
                            height: mediaHeight*0.04,
                            width: mediaWidth*0.8,
                            imageProvider: AssetImage('assets/images/profilememini.png'),
                            text1: '_',
                            text2: '가면말티즈',
                            text3: null,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15
                            )),
                      )
                    ],
                  )
                ],
              ),
            )
        ),
        Positioned(
            bottom: mediaHeight*0.04,
            left: mediaWidth / 2 - 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFFFDD987),
                        Color(0xFFF79CC3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  ),
                  border: Border.all(
                      color: Colors.white,
                      width: 3
                  )
              ),
              child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: (){}, child: Icon(Icons.stop_rounded, size: 45)),
            )
        ),

      ],
    );
  }
}
