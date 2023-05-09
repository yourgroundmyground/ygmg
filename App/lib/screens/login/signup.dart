import 'dart:convert';
import 'dart:io';
import 'package:app/const/state_provider_screen.dart';
import 'package:app/screens/game/game_start.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';


//객체 정의
class JoinMemberPostReq {
  final String memberNickname;
  final int memberWeight;
  final String kakaoEmail;
  final String memberBirth;
  final String memberName;


  JoinMemberPostReq ({
    required this.memberNickname,
    required this.memberWeight,
    required this.kakaoEmail,
    required this.memberBirth,
    required this.memberName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberNickname'] = this.memberNickname;
    data['memberWeight'] = this.memberWeight;
    data['kakaoEmail'] = this.kakaoEmail;
    data['memberBirth'] = this.memberBirth;
    data['memberName'] = this.memberName;
    print('데이터 $data');
    return data;
  }
}

//닉네임 중복 확인
Future<String> checkNickname(String nickname) async {
  Dio dio = Dio();
  try {
    var encodedNickname = Uri.encodeComponent(nickname);
    var response = await dio.get(
        "http://k8c107.p.ssafy.io:8080/api/member/$nickname",
        queryParameters: {"memberNickname": encodedNickname});

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      print(response.data);
      return response.data;
    }
  } catch (e) {
    print(e);
    return '닉네임 체크 에러 발생';
  }
}



class SignUpScreen extends StatefulWidget {
  final String kakaoEmail;
  final String memberBirth;
  final String memberName;

  const SignUpScreen({
    required this.kakaoEmail,
    required this.memberBirth,
    required this.memberName,
    Key? key
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _image = null;
  bool _isNicknameValid = false; //닉네임 중복 확인
  final picker = ImagePicker();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<_NicknameFieldState> _nicknameFieldKey = GlobalKey<_NicknameFieldState>();

  //프로필 이미지 선택
  Future selectImage() async {
    final pickedProfileImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedProfileImage == null) {
      setState(() {
        _image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지를 선택해주세요')),
      );
      return;
    }
    setState(() {
      _image = File(pickedProfileImage.path);
    });
  }

  Future uploadData() async {
    var dio = Dio();

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지를 선택해주세요')),
      );
      return;
    }

    //객체 생성
    JoinMemberPostReq  joinMemberPostReq = JoinMemberPostReq (
      memberNickname: _nicknameController.text,
      memberWeight: int.parse(_weightController.text),
      kakaoEmail: widget.kakaoEmail,
      memberBirth: widget.memberBirth,
      memberName: widget.memberName,
    );

    Map<String, dynamic> jsonData = joinMemberPostReq.toJson();
    print('joinMemberPostReq : $jsonData');

    FormData formData = FormData.fromMap({
      "profile": await MultipartFile.fromFile(_image!.path),
      "joinMemberPostReq": MultipartFile.fromString(
        jsonEncode(joinMemberPostReq),
        contentType: MediaType('application','json'),
      )
    });


    try {
      final response = await dio.post(
        'http://k8c107.p.ssafy.io:8080/api/member/app',
        data: formData,
        options: Options(
          // method: 'POST',
          // headers: {
          // Headers.contentTypeHeader: 'multipart/form-data'
          // 'Content-Type': 'application/json',
          // },
        ),
      );

      print('회원가입 성공! $response.data');

      if (response.data['statusCode'] == 200) {
        int memberId = response.data['tokenInfo']['memberId'];
        String memberNickname = response.data['tokenInfo']['memberNickname'];
        double memberWeight = response.data['tokenInfo']['memberWeight'].toDouble();
        String accessToken = response.data['tokenInfo']['authorization'];
        String refreshToken = response.data['tokenInfo']['refreshToken'];

        TokenInfo tokenInfo = TokenInfo(
          memberId: memberId,
          memberNickname: memberNickname,
          memberWeight: memberWeight,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        print('회원가입 성공???????? $response.data');
        await saveTokenSecureStorage(tokenInfo);
        print('회원가입 성공~~ $response.data');
        return true;

      }
      return false;
    } on DioError catch (e) {
      if (e.response != null) {
        print('에러 응답 코드: ${e.response!.statusCode}');
        print('에러 응답 데이터: ${e.response!.data}');
      } else {
        print('에러e: $e');
      }
    }
    // catch (e) {
    //   print('에러c: $e');
    // }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    return Container(
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.1),//마진수정
                            child: Text('닉네임',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: mediaWidth*0.7,
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
                                    onPressed: () async {
                                      // checkNickname(_nicknameController.text);

                                      String nicknameCheckMessage = await checkNickname(_nicknameController.text);

                                      if (nicknameCheckMessage == '사용가능한 닉네임입니다.') {
                                        _isNicknameValid = true;
                                        _nicknameFieldKey.currentState
                                            ?.updateMessages(newHintText: nicknameCheckMessage, newErrorText: null);
                                        print('닉네임 사용가능');

                                      } else if (nicknameCheckMessage == '중복된 닉네임입니다.') {
                                        _isNicknameValid = false;
                                        _nicknameFieldKey.currentState
                                            ?.updateMessages(newHintText: '닉네임을 입력하세요', newErrorText: nicknameCheckMessage);
                                        print('닉네임 사용불가');

                                      }



                                    },
                                    child: Text('중복확인'))
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('몸무게'),
                          const SizedBox(width: 10),
                          Container(
                            width: mediaWidth*0.6,
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
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 80),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: _isNicknameValid
                              ? () {
                            if (_formKey.currentState!.validate()) {
                              uploadData().then((response) {
                                if (response ?? false) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => GameStart()),
                                      (route) => false,
                                  );
                                }
                              });
                            }
                          }
                              : null, //버튼 비활성화
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              _isNicknameValid ? Color(0xFFFFDA65) : Colors.grey,
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
    );
  }
}



class NicknameField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? errorText;

  const NicknameField({
    this.controller,
    this.onChanged,
    this.hintText,
    this.errorText,
    Key? key}) : super(key: key);

  @override
  State<NicknameField> createState() => _NicknameFieldState();
}

class _NicknameFieldState extends State<NicknameField> {
  String? hintText;
  String? errorText;

  void updateMessages({String? newHintText, String? newErrorText}) {
    setState(() {
      hintText = newHintText;
      errorText = newErrorText;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('hint mesage $hintText');

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

            controller: widget.controller,
            cursorColor: Colors.teal,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: widget.onChanged,
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
              focusedBorder: InputBorder.none, //밑줄 없애기
              hintText: hintText ?? '닉네임을 입력하세요',
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
  final ValueChanged<String>? onChanged;

  const WeightField({
    this.controller,
    this.hintText,
    this.errorText,
    this.onChanged,
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
            onChanged: onChanged,
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
                return '몸무게를 입력하세요';
              } else {
                int? parsedValue = int.tryParse(value);
                if (parsedValue == null || parsedValue > 400 || parsedValue < 10) {
                  return '실제 몸무게가 맞나요?';
                }
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}