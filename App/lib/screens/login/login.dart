import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/mainbg.png'),
        ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(top: mediaHeight*0.05),
                  child: Image.asset('assets/images/mainlogo.png')),
              Container(
                margin: EdgeInsets.only(top: mediaHeight*0.02),
                child: GestureDetector(
                  onTap: (){
                    //이미지 클릭시 실행할 코드

                  },
                  child: Image.asset('assets/images/kakao_login_medium_wide.png'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      //이미지 클릭시 실행할 코드

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: mediaWidth*0.4),
                      margin: EdgeInsets.only(top: mediaHeight*0.01),
                      child: Text('니땅내땅이 처음이세요?',
                          style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
                    )),
                ]),
              ]
            ),
          ),
        );
  }
}
