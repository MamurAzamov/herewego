import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/service/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = 'signup_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void _doSignUp() {
    String fullname = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(fullname.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signUpUser(fullname, email, password).then((value) => {
      responseSignUp(value!)
    });
  }

  void responseSignUp(User firebaseUser){
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  void _callSignInPage() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
                      child: TextField(
                        controller: fullnameController,
                        decoration: const InputDecoration(
                            hintText: 'Fullname',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
                      child: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18)
                        ),
                      ),
                    ),
                    isLoading ? const Center(
                      child: CircularProgressIndicator(),
                    ) : const SizedBox.shrink(),
                  ],
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
                height: 45,
                width: double.infinity,
                color: Colors.red,
                child: InkWell(
                  onTap: _doSignUp,
                  child: const Center(
                    child: Text("Sign Up",style:
                    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                  ),
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Already have an account?",style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap: _callSignInPage,
                    child: const Text("Sign In",style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
