import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  // final String kakaoEmail;
  // final String memberBirth;
  // final String memberName;

  const SignUpScreen({
    // required this.kakaoEmail,
    // required this.memberBirth,
    // required this.memberName,
    Key? key
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  //갤러리에서 프로필 이미지 선택
  Future selectImage() async {
    final pickedProfileImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedProfileImage != null) {
      setState(() {
        _image = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지를 선택해주세요')),
      );
      return;
    }
    setState(() {
      _image = File(pickedProfileImage.path);
    }
    );
  }


  Future uploadData() async {
    String url = "https://your-server-endpoint";
    Dio dio = Dio();

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지를 선택해주세요')),
      );
      return;
    }


    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(_image!.path),
      "nickname": _nicknameController.text,
      "weight": _weightController.text,
      // "kakaoEmail": widget.kakaoEmail,
      // "memberBirth": widget.memberBirth,
      // "memberName": widget.memberName,
    });

    try {
      var response = await dio.post(url, data: formData);
      print('성공');
      print(response);
    } catch (e) {
      print('에러');
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        height: 167,
                        width: 167,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0,3)

                          )]
                        ),
                        child: _image == null
                          ? Container(
                          width: 167,
                          height: 167,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child:Image.asset('assets/images/plus.png')
                        )
                          : ClipOval(
                          child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('닉네임'),
                        Container(
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
                                controller: _nicknameController,
                                hintText: '닉네임을 입력하세요',
                              ),
                              ElevatedButton(
                                  onPressed: (){

                                  },
                                  child: Text('중복확인'))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('몸무게'),
                        Container(
                          width: mediaWidth*0.45,
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
                              WeightField(
                                controller: _weightController,
                                hintText: '몸무게를 입력하세요',
                              ),
                              Text('kg'),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 80),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            if (_formKey.currentState!.validate()) {
                              uploadData();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFDA65),
                              elevation: 8
                          ),
                          child: Text('확인', style: TextStyle(color: Colors.black)),
                      )
                    ]
                    )
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class NicknameField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;

  const NicknameField({
    this.controller,
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
            controller: controller,
            cursorColor: Colors.teal,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.length>8) {
                return '8글자를 넘을 수 없습니다';
              } else if (!RegExp(r'^[가-힣a-zA-Z0-9]+$').hasMatch(value)) {
                return '특수문자는 사용할 수 없습니다';
              } else {
                return null;
              }
            },
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

class WeightField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;

  const WeightField({
    this.controller,
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
          width: mediaWidth*0.4,
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.teal,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: hintText,
              errorText: errorText,
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
              border: baseBorder,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '몸무게를 입력해주세요';
              } else if (int.parse(value) > 400 || int.parse(value) <10) {
                return '실제 몸무게가 맞나요?';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}



