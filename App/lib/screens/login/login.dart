import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(

          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Image.asset('assets/images/MainLogo.png'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    ),
                    onPressed: (){},
                    child: Text('카카오로그인')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('니땅내땅이 처음이세요?')
                  ],
                )
              ]
          ),
        )
        )
      );
  }
}
