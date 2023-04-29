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
          color: Colors.deepPurple,
        ),
        Positioned(
            left: mediaWidth*0.01,
            top: mediaHeight*0.03,
            child: Container(
              //왼쪽 위 모달
              width: 200,
              color: Colors.amber,
              child: Column(
                children: [
                  Text('시간모달', style: TextStyle(fontSize: 20,color: Colors.black),),
                  Text('차지면적', style: TextStyle(fontSize: 20,color: Colors.black),)
                ],
              ),
            ),
        ),
        Positioned(
            right: mediaWidth*0.01,
            top: mediaHeight*0.03,
            child: Container(
              //오른쪽 위 모달
              width: 200,
              color: Colors.green,
              child: Column(
                children: [
                  Text('실시간 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
                  Text('현재 내 순위', style: TextStyle(fontSize: 16, color: Colors.black))
                ],
              ),
            )
        ),
        Positioned(
            bottom: mediaHeight*0.01,
            right: mediaWidth*0.45,
            child: FloatingActionButton(
                backgroundColor: Colors.deepOrangeAccent,
                onPressed: (){}, child: Icon(Icons.stop))
        ),
      ],
    );
  }
}
