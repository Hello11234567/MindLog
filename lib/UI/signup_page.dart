//회원가입 화면
import 'package:flutter/material.dart';
import '../function/signup_function.dart'; //회원가입 기능 파일
import '../UI/login_page.dart'; //회원가입 성공 시 로그인 화면으로 이동

class SignUpPage extends StatefulWidget {
    const SignUpPage({super.key});

    @override
    State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
    //입력 컨트롤러
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController birthdayController = TextEditingController();
    final TextEditingController phonenumberController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: true, //키보드에 맞춰 화면 자동 조정
            appBar: AppBar(title: const Text('회원가입')),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:24, vertical: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                    labelText: '이메일',
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                    labelText: '비밀번호',
                                    border: OutlineInputBorder(),
                                ),
                                obscureText: true, //비밀번호 숨김
                            ),
                            const SizedBox(height: 16),

                            TextField(
                                controller: nameController,
                                keyboardType: TextInputType.text, //한글 입력 가능
                                inputFormatters: [], //한글을 막는 규칙이 있으면 제거
                                decoration: const InputDecoration(
                                    labelText: '이름',
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                                controller: birthdayController,
                                decoration: const InputDecoration(
                                    labelText: '생일 (YYYY-MM-DD)',
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                                controller: phonenumberController,
                                decoration: const InputDecoration(
                                    labelText: '전화번호 (-없이 입력)',
                                    border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                                onPressed: () => signUp(
                                    context,
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    nameController.text.trim(),
                                    birthdayController.text.trim(),
                                    phonenumberController.text.trim(),
                                ),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                    ),
                                ),
                                child: const Text('회원가입'),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}