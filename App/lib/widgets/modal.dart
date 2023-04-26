import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  const CustomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameRankModal();     // *현재 페이지가 뭐인지에 따라서 모달이 나오도록 추후에 설정하기
  }
}

class GameRankModal extends StatelessWidget {
  const GameRankModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 크기
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 모달 최종순위
    const finalRank = 10322;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
          width: mediaWidth*0.8,
          height: mediaHeight*0.25,
          child: Padding(
            padding: EdgeInsets.fromLTRB(mediaWidth*0.08, mediaHeight*0.03, mediaWidth*0.05, mediaHeight*0.03),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('최종 순위',
                        style: TextStyle(
                            fontSize: mediaWidth*0.05,
                            fontWeight: FontWeight.w700,
                            color: TEXT_GREY,
                            letterSpacing: 2
                        ),
                      ),
                      IconButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.close),
                        iconSize: mediaWidth*0.08,
                      )
                    ]
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, mediaHeight*0.03, 0, mediaHeight*0.03),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10,
                        ),
                        children: [
                          TextSpan(
                            text: '$finalRank ',
                            style: TextStyle(
                              fontSize: mediaWidth * 0.1,
                              color: YGMG_RED,
                            ),
                          ),
                          TextSpan(text: '위',
                              style: TextStyle(
                                  fontSize: mediaWidth * 0.06,
                                  color: Colors.black
                              )
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          )
      ),
    );
  }
}

