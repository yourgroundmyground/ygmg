import 'package:app/widgets/game_result.dart';
import 'package:app/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';

class DailyRunning extends StatelessWidget {
  const DailyRunning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
              image : DecorationImage(
                  image : AssetImage('assets/images/runningbgi.png'),
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, mediaHeight*0.03, 0, mediaHeight*0.1),
                  child: Text('나의 달리기 결과', style: TextStyle(
                      fontSize: mediaWidth*0.07,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),),
                ),
                SizedBox(height: mediaHeight*0.04,),
                Container(
                  width: mediaWidth*0.7,
                  height: mediaHeight*0.35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mediaWidth*0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 28,
                        ),
                      ],
                      image : DecorationImage(
                        // 저장한 경로 이미지? 지도?
                          image : AssetImage('assets/images/running-gif.gif'),
                          fit : BoxFit.fitWidth,
                          alignment: Alignment.topLeft,
                          repeat: ImageRepeat.noRepeat
                      )
                  ),
                ),
                SizedBox(height: mediaHeight*0.05,),
                GameResultInfo()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
