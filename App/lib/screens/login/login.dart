import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        width: double.infinity,
        decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/mainbg.png'),
        ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/mainlogo.png'),
              ElevatedButton(onPressed: (){}, child: Text('카카오로그인')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){}, child: Text('니땅내땅이 처음이세요?'),)
                ],
              )
            ],
          ),
        ),
        // child: Scaffold(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //         children:[
        //           Image.asset('images/mainlogo.png'),
        //           ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               ),
        //               onPressed: (){},
        //               child: Text('카카오로그인')),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text('니땅내땅이 처음이세요?')
        //             ],
        //           )
        //         ]
        //     ),
        //   ),
        )
      );
  }
}
