//로그인 기능
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> loginUser(BuildContext context, String email, String password) async {
    try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        //로그인 성공 시 홈 화면으로 이동
        Navigator.pushReplacementNamed(context, '/home');

        return true;
    } on FirebaseAuthException catch (e) {
        String message = "로그인 실패";
        if (e.code == 'user-not-fount') {
            message = "존재하지 않는 계정입니다.";
        } else if (e.code == 'wrong-password') {
            message = "비밀번호가 일치하지 않습니다.";
        }

        ScaffoldMessenger.of(context).showSnackBar (
            SnackBar(content: Text(message)),
        );
        return false;
    }
}

//회원가입 페이지로 이동
void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
}

//아이디/비밀번호 찾기 페이지로 이동
void navigateToFindAccount(BuildContext context) {
    Navigator.pushNamed(context, '/findAccount');
}