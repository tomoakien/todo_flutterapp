import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';

import 'registration.dart';
import 'todo.dart';

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
  String? mailAddress = 'test@example.com';
  String? password = 'password123';
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
