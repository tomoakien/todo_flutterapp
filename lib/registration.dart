import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:todo_app/main.dart';

class Registration extends StatelessWidget {
  Registration({Key? key}) : super(key: key);

  String? mailAddress;
  String? password;
  String? passwordCheck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新規登録"),
        ),
        body: Column(
          children: [
            CustomTextField(
              label: "メールアドレス",
              onChangedfunc: (newText) {
                mailAddress = newText;
              },
              isPassword: false,
            ),
            CustomTextField(
              label: "パスワード",
              onChangedfunc: (newText) {
                password = newText;
              },
              isPassword: true,
            ),
            CustomTextField(
              label: "パスワード確認",
              onChangedfunc: (newText) {
                passwordCheck = newText;
              },
              isPassword: true,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (passwordCheck != password) {
                    //パスワードの入力欄と確認欄が等しくなかったら
                    showDialog(
                        //ダイアログを表示させる
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("エラー"),
                            content: Text("パスワードを正しく入力して下さい。"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"))
                            ],
                          );
                        });
                  } else {
                    if (mailAddress != null && password != null) {
                      //メールアドレスとパスワードがnullでない場合
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: mailAddress!, password: password!);
                        final User user = userCredential.user!;
                        FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc('0')
                            .set({'item': 'ToDoを始めてみよう!', 'done': false});
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text("登録しました"),
                                  content: Text("登録完了しました"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                        },
                                        child: Text("OK"))
                                  ]);
                            });
                        //Navigator.push(MaterialPage(context)=>Text("OK"))
                      } on FirebaseAuthException catch (e) {
                        print(e.toString());
                        if (e.code == 'weak-password') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("エラー"),
                                  content: Text("パスワードが短すぎます。"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"))
                                  ],
                                );
                              });
                        } else if (e.code == 'email-already-in-use') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("エラー"),
                                  content: Text("入力されたメールアドレスは既に使われています。"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"))
                                  ],
                                );
                              });
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("エラー"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              );
                            });
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("エラー"),
                              content: Text("正しく入力して下さい"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ],
                            );
                          });
                    }
                  }
                },
                child: Container(
                    width: 200,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '新規登録',
                      textAlign: TextAlign.center,
                    )))
          ],
        ));
  }
}
