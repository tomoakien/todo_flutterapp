import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';

import 'registration.dart';
import 'todo.dart';
import 'autherror.dart';

void main() async {
  //以下Firebaseを使用する際の宣言
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String? mailAddress;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ログイン画面")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "ToDoアプリ",
                    style: TextStyle(fontSize: 50),
                  ),
                  Text("ログインして下さい"),
                ],
              )),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("新規登録は"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Registration()));
                  },
                  child: Text("こちら"))
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: mailAddress!,
                    password: password!,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Todo(
                                user: userCredential.user!,
                              )));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("エラー"),
                              content: Text("メールアドレスが見つかりません。"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ]);
                        });
                  } else if (e.code == 'wrong-password') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("エラー"),
                            content: Text("パスワードが違います。"),
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
                    'ログイン',
                    textAlign: TextAlign.center,
                  )))
        ],
      ),
    );
  }

//Firebaseでのログイン内部処理関数
  Future<FirebaseAuthResultStatus> signIn(
      {String? email, String? password}) async {
    FirebaseAuthResultStatus result;
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      if (userCredential.user == null) {
        // ユーザーが取得できなかったとき
        result = FirebaseAuthResultStatus.Undefined;
      } else {
        // ログイン成功時
        result = FirebaseAuthResultStatus.Successful;
      }
    } on FirebaseAuthException catch (e) {
      // エラー時
      result = FirebaseAuthExceptionHandler.handleException(e);
    }
    return result;
  }

//ログイン実行関数
  void login(BuildContext context) async {
    final FirebaseAuthResultStatus result = await signIn(
      email: mailAddress,
      password: password,
    );

    if (result == FirebaseAuthResultStatus.Successful) {
      // ログイン成功時の処理
    } else {
      // ログイン失敗時の処理
      final errorMessage =
          FirebaseAuthExceptionHandler.exceptionMessage(result);
      // エラー情報をユーザーに何かで通知
      _showErrorDialog(context, errorMessage);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}

//カスタムウィジェットとして部品化
class CustomTextField extends StatelessWidget {
  String label; //ラベルとしてパラメータを持つ
  void Function(String text) onChangedfunc;
  bool isPassword;

  CustomTextField({
    required this.label,
    required this.onChangedfunc,
    required this.isPassword,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (newText) {
          onChangedfunc(newText);
        },
        obscureText: isPassword
            ? true
            : false, //obscureTextプロパティを使用する。isPasswordフラグがtrueならtrueにする
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
