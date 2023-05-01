import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';

class InRunning extends StatelessWidget {
  const InRunning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
              image: AssetImage('assets/images/runningbgi.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
                repeat: ImageRepeat.noRepeat,
              )
            ),
            child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.1, mediaWidth*0.1, mediaHeight*0.05),
                child: Text('잘 하고 있어요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mediaWidth*0.07,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1
                  )
                ),
              ),
              Container(
                width: mediaWidth*0.75,
                height: mediaWidth*0.75,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle
                ),
                // child: Image.asset(''),
                child: Text('달리는 이미지',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: mediaHeight*0.07,),
              GameResultInfo()    //  *running_info 위젯으로 변경하기
            ]
          )
        )
      )
    );
  }
}
