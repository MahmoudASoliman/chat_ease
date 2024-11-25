import 'package:chat_app/widgets/constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/showsnakebar.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'RegisterPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  String? phoneNumber;
  String? address;

  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
                const Padding(
                  padding: EdgeInsets.only(right: 256),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                CustomTextform(
                  hint: 'Email',
                  onchanged: (data) {
                    email = data;
                  },
                ),
                CustomTextform(
                  hint: 'Password ',
                  onchanged: (data) {
                    password = data;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Custombutton(
                    type: "Register",
                    ontape: () async {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        try {
                          await Registeruser();

                          Showsnakebar(context: context, message: 'Success');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Showsnakebar(
                                context: context,
                                message: 'The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            Showsnakebar(
                                context: context,
                                message: 'This Email is already registered');
                          }
                        } catch (ex) {
                          print("ex>>$ex");
                          Showsnakebar(
                              context: context, message: "An error occurred");
                        } finally {
                          setState(() {
                            isloading = false;
                          });
                        }
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
                        "Already have an account  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFFC7EDE6),
                          ),
                        ),
                      ),
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

  Future<void> Registeruser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // Update user information with phone number and address in the database
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'phoneNumber': phoneNumber,
        'address': address,
      });

      print('User registered successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Showsnakebar(
            context: context, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Showsnakebar(
            context: context, message: 'This Email is already registered');
      } else {
        Showsnakebar(context: context, message: "An error occurred");
      }
    } catch (ex) {
      Showsnakebar(context: context, message: "An error occurred");
    }
  }
}
