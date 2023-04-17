import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/post_model.dart';
import '../service/auth_service.dart';
import '../service/rtdb_service.dart';
import '../service/storage_service.dart';

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

  File? _image;
  final picker = ImagePicker();

  _createPost() {
    String firstname = firstnameController.text.toString();
    String lastname = lastnameController.text.toString();
    String data = dataController.text.toString();
    String content = contentController.text.toString();
    if (firstname.isEmpty || lastname.isEmpty || data.isEmpty || content.isEmpty) return;
    if(_image == null) return;
    _apiUploadImage(firstname, lastname, data, content,);
  }

  _apiUploadImage(String firstname, String lastname, String data, String content,){
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!).then((img_url) => {
      _apiCreatePost(firstname, lastname, data, content, img_url),
    });
  }

  _apiCreatePost(String firstname, String lastname, String data, String content, String img_url) {
    setState(() {
      isLoading = true;
    });
    var post =
    Post(firstname: firstname, lastname: lastname, data: data, content: content, img_url: img_url, userId: AuthService.currentUserId());
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

  void _getImage()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
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
                InkWell(
                  onTap: _getImage,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: _image != null ? Image.file(_image!, fit: BoxFit.cover,) :
                    Image.asset('assets/images/upload.png'),
                  ),
                ),
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
