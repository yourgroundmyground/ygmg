import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

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
                Column(
                  children: [
                    Text('닉네임'),
                    Row(
                      children: [
                        SizedBox(
                          width: mediaWidth*0.7,
                          height: 100,
                          child: NicknameField(
                            hintText: '닉네임을 입력하세요',
                            errorText: '중복되었습니다',
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            onPressed: (){},
                            child: Text('중복확인'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('성별'),
                        Text('나이')
                      ],
                    ),
                    ElevatedButton(
                        onPressed: (){},
                        child: Text('확인', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow
                    ))
                  ],
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
    final baseBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0
      )
    );

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            cursorColor: Colors.teal,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
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

