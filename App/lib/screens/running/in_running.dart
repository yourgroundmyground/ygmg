import 'package:app/widgets/running_info.dart';
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
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/running-gif.gif'),
                  radius: mediaWidth*0.4,

                ),
              ),
              SizedBox(height: mediaHeight*0.07,),
              RunningInfo()    //  *running_info 위젯으로 변경하기
            ]
          )
        )
      )
    );
  }
}
