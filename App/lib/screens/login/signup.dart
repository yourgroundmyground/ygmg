import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Container(
        // width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/mainbg2.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                    },
                    child: Image.asset('assets/images/addprofile.png'),
                  ),
                  Text('닉네임'),
                  SizedBox(
                      child: Container(
                        width: mediaWidth*0.85,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: Offset(0,3)
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NicknameField(
                              hintText: '닉네임을 입력하세요',
                            ),
                            ElevatedButton(
                                onPressed: (){},
                                child: Text('중복확인'))
                          ],
                        ),
                      )
                  ),
                  ElevatedButton(
                      onPressed: (){},
                      child: Text('확인', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFDA65),
                          elevation: 8
                      )
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}

class NicknameField extends StatelessWidget {
  final String? hintText;
  final String? errorText;

  const NicknameField({
    this.hintText,
    this.errorText,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final baseBorder = UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black,
            width: 1.0
        )
    );

    return Row(
      children: [
        SizedBox(
          width: mediaWidth*0.6,
          child: TextFormField(
            cursorColor: Colors.teal,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: hintText,
              errorText: errorText,
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
              border: baseBorder,
            ),
          ),
        ),
      ],
    );
  }
}

