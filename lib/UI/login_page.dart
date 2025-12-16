//로그인 화면
import 'package:flutter/material.dart';
import '../function/login_function.dart';
import '../UI/home_page.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    bool _isLoading = false;

    void _handleLogin() async {
        setState(() => _isLoading = true);

        final success = await loginUser(
            context,
            emailController.text.trim(),
            passwordController.text.trim(),
        );

        setState(() => _isLoading = false);

        if(success) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("로그인 성공!")),
            );
            Navigator.pushReplacementNamed(context, '/home');
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: true, //키보드에 맞춰 화면 자동 조정
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text(
                                "MindLog",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 40),

                            //이메일 입력
                            TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                    labelText: "이메일",
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 20),

                            //비밀번호 입력
                            TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: "비밀번호",
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 30),

                            //로그인 버튼
                            ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                ),
                                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("로그인"),
                            ),
                            const SizedBox(height: 15),

                            //아이디/비밀번호 찾기
                            TextButton(
                                onPressed: () => navigateToFindAccount(context),
                                child: const Text("아이디/비밀번호 찾기"),
                            ),
                            const SizedBox(height: 10),

                            //회원가입 이동
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Text("아직 회원이 아니신가요?"),
                                    TextButton(
                                        onPressed: () => navigateToSignUp(context),
                                        child: const Text("회원가입"),
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
