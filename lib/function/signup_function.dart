//회원가입 기능
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//회원가입 함수
Future<void> signUp(
    BuildContext context,
    String email,
    String password,
    String name,
    String birthday,
    String phonenumber,
) async {
    try {
        //Firebase Auth에 계정 새성
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
        );

        //Firestore에 정보 저장
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'email': email,
            'password': password,
            'name': name,
            'birthday': birthday,
            'phone': phonenumber,
            'createdAt': DateTime.now(),
        });

        //회원가입 성공 알림
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('회원가입 완료!')));

        //로그인 페이지로 돌아가기
        Navigator.pop(context);
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패: $e')));
    }
}