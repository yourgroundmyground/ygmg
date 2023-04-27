import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';

class RunningDetail extends StatelessWidget {
  const RunningDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *날짜 변경
    const month = 4;
    const day = 20;
    const time = '10:23AM';

    return Scaffold(
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(mediaWidth*0.07, mediaHeight*0.05, mediaWidth*0.07, mediaHeight*0.02),
            // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$month월 $day일 $time',
                      style: TextStyle(
                        fontSize: mediaWidth*0.08,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Image.asset('assets/images/closebtn.png'))
                  ],
                ),
                SizedBox(height: mediaHeight*0.04,),
                Container(
                  width: mediaWidth*0.7,
                  height: mediaHeight*0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mediaWidth*0.02),
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mediaHeight*0.05,),
                GameResultInfo()

              ],
            ),
          ),
        ),
      ),
    );
  }
}
