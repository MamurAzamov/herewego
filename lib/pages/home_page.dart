import 'package:flutter/material.dart';
import 'package:herewego/service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: (){
            AuthService.signOutUser(context);
          },
          color: Colors.deepOrange,
          child: const Text("LogOut",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
