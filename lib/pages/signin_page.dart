import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signup_page.dart';
import 'package:herewego/service/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = 'signin_page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void _callSignUpPage() =>
      Navigator.pushNamed(context, SignUpPage.id);

  void _doSignIn(){
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signInUser(email, password).then((value) => {
      responseSignIn(value!)
    });
  }

  void responseSignIn(User firebaseUser){
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
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
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 18)
                      ),
                    ),
                  ),
                ],
              ),
              isLoading ? const Center(
                child: CircularProgressIndicator(),
              ) : const SizedBox.shrink(),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
            height: 45,
            width: double.infinity,
            color: Colors.red,
            child: InkWell(
              onTap: _doSignIn,
              child: const Center(
                child: Text("Sign In",style:
                TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
              ),
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Don't have an account?",style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: _callSignUpPage,
                  child: const Text("Sign Up",style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
