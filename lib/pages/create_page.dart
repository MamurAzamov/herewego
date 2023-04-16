import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../service/auth_service.dart';
import '../service/rtdb_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var isLoading = false;
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var dataController = TextEditingController();
  var contentController = TextEditingController();

  _createPost() {
    String firstname = firstnameController.text.toString();
    String lastname = lastnameController.text.toString();
    String data = dataController.text.toString();
    String content = contentController.text.toString();
    if (firstname.isEmpty || lastname.isEmpty || data.isEmpty || content.isEmpty) return;

    _apiCreatePost(firstname, lastname, data, content);
  }

  _apiCreatePost(String firstname, String lastname, String data, String content,) {
    setState(() {
      isLoading = true;
    });
    var post =
    Post(firstname: firstname, lastname: lastname, data: data, content: content, userId: AuthService.currentUserId());
    RTDBService.addPost(post).then((value) => {
      _resAddPost(),
    });
  }

  _resAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Container(
        padding: const EdgeInsets.all(22),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: firstnameController,
                  decoration: const InputDecoration(
                    hintText: 'FirstName',
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: lastnameController,
                  decoration: const InputDecoration(
                    hintText: 'LastName',
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    hintText: 'Date',
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: MaterialButton(
                    onPressed: (){
                      _createPost();
                    },
                    color: Colors.deepOrange,
                    child: const Text("Add", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
            isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
