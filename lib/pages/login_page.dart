import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/showsnakebar.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? emailAddress;
  bool obscureText = true;
  String? password;

  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Image.asset(
                    'assets/images/scholar.png',
                    height: 100,
                  ),
                ),
                const Center(
                  child: Text(
                    "Scholar chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                CustomTextform(
                  hint: 'Email',
                  onchanged: (data) {
                    emailAddress = data;
                  },
                ),
                CustomTextform(
                  obscureText: obscureText,
                  icon: IconButton(
                    icon: const Icon(
                      Icons.visibility_off,
                    ),
                    onPressed: () {
                      obscureText == false
                          ? obscureText = true
                          : obscureText = false;
                      setState(() {});
                    },
                  ),
                  hint: 'Password ',
                  onchanged: (data) {
                    password = data;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Custombutton(
                    type: "Sign up",
                    ontape: () async {
                      if (formkey.currentState!.validate()) {
                        isloading = true;
                        setState(() {});
                        try {
                          await User_Login();
                          Navigator.pushNamed(context, ChatPage.id,
                              arguments: emailAddress);
                          Showsnakebar(context: context, message: "Succes!");
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            Showsnakebar(
                                context: context,
                                message: "No user found for that email.");
                          } else if (e.code == 'wrong-password') {
                            Showsnakebar(
                                context: context,
                                message:
                                    'Wrong password provided for that user.');
                          }
                        } catch (ex) {
                          Showsnakebar(
                              context: context, message: "There is an error");
                        }

                        isloading = false;
                        setState(() {});
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "don't have an account ? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFFC7EDE6),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> User_Login() async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress!, password: password!);
  }
}
