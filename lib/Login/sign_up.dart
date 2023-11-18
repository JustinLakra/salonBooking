import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Components/database.dart';
import '../Components/myButton.dart';
import '../Components/utils.dart';
import '../main.dart';

//widget that deals with sign up
class SignUpWidget extends StatefulWidget {
  //function to help route auth
  final Function() onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {

  //controllers to store form data
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  //dispose is used to prevent memory leaks and data stealing
  void dispose() {

    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text("Sign Up", style: TextStyle(fontFamily: "Open Sans",fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                style: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                controller: nameController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Name',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                  labelStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                ),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (name) =>
                    // ignore: prefer_is_empty
                    name!.length == 0 ? 'Enter a valid name' : null,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                style: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                controller: phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                          enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                  labelStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                ),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (clas) => (clas == null ||
                        int.parse(clas) < 1000000000 ||
                        int.parse(clas) > 9999999999)
                    ? 'Enter a valid 10 digit no.'
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                style: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
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
                  hintStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                  labelStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null &&
                        !EmailValidator.validate(email) &&
                        !email.startsWith("xcode.xcs")
                  && email.toString().toLowerCase() != "guest@xavcomsociety.com"
                    ? 'Enter a valid email'
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                style: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
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
                  hintStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                  labelStyle: const TextStyle(fontFamily: "Open Sans",color: Colors.black),
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter minimum 6 characters'
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            MyButton(
                onTap: () {
                  signUp();
                },
                text: "Sign Up"),
            const SizedBox(height: 20),
            RichText(
                text: TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = widget.onClickedSignIn,
              style: const TextStyle(fontFamily: "Open Sans",
                  color: Colors.white, fontSize: 20, ),
              text: 'Already Have An Account? Log In!',
            )),
            const SizedBox(height: 50),
          ]),
        ),
      )),
    );
  }

//main signup function, that handles the signup
  Future<void> signUp() async {
    //checks for form validity
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      //trying to create user and login
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      //setting initial user data using the databse service.dart file to cloud firestore
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .setInitialUserData(
        nameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),

      );
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(nameController.text.trim());
    } on FirebaseAuthException catch (e) {
      //exception handling
      Utils.showSnackBar(e.message);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
    //updating the display name
    //popping to first route so that auth state change takes place
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
