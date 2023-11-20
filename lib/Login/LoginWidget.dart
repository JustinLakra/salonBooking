// ignore_for_file: file_names

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Components/myButton.dart';
import '../Components/utils.dart';
import '../main.dart';
import 'Forgot_Password_Page.dart';

//tasked with login and sign up routing
class LoginWidget extends StatefulWidget {
  //Helps switch between login and signup
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  //stores the form data
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //form key is used to check if form has been filled properly or not
  final formKey = GlobalKey<FormState>();

  @override
  //dispose to prevent memory leaks and data leaks
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  //Log in screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Center(
        child: Form(
          child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
             SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset("assets/salonLogo.jpg")),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: emailController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Email',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: passwordController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter minimum 6 characters'
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Forgot  Password?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Sarabun",
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage(),
              )),
            ),
            const SizedBox(height: 20),
            MyButton(onTap: signIn, text: "Sign In"),
            const SizedBox(height: 20),
            RichText(
                text: TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = widget.onClickedSignUp,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Sarabun"),
              text: 'No account? Sign Up!',
            )),
                const SizedBox(height: 20),
          ]),
        ),
      )),
    );
  }

//function for signing in on clicking sign in
  Future<void> signIn() async {
    //showing progress indicartor
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //trying to authenticate
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //exception handling
      String message ="";
      switch(e.code){
        case "invalid-email":
          message = "The email address entered is invalid.";
          break;
        case "wrong-password":
          message = "The password address entered is incorrect.";
          break;
        case "user-not-found":
          message = "User doesn't exist. Please login or reset your password";
          break;
        case "user-is-disabled":
          message = "The user has been disabled by the administrators";
          break;
        default:
          message = "Please enter all fields and try again.";
      }
      Utils.showSnackBar(message);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
    //going to parent route
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
  Future<void> signInAsGuest() async {
    //showing progress indicartor
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //trying to authenticate
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'guest@xavcomsociety.com',
        password: '123456',
      );
    } on FirebaseAuthException catch (e) {
      //exception handling
      String message ="";
      switch(e.code){
        case "invalid-email":
          message = "The email address entered is invalid.";
          break;
        case "wrong-password":
          message = "The password address entered is incorrect.";
          break;
        case "user-not-found":
          message = "User doesn't exist. Please login or reset your password";
          break;
        case "user-is-disabled":
          message = "The user has been disabled by the administrators";
          break;
        default:
          message = "Please enter all fields and try again.";
      }
      Utils.showSnackBar(message);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
    //going to parent route
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
