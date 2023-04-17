import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:herewego/service/auth_service.dart';

import '../model/post_model.dart';
import '../service/rtdb_service.dart';
import 'create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  Future _callCreatePage() async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const CreatePage();
    }));
    if (results != null && results.containsKey("data")) {
      print(results['data']);
      _apiPostList();
    }
  }

  _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var list = await RTDBService.getPosts();
    items.clear();
    setState(() {
      items = list;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Posts"),
        actions: [
          IconButton(
              onPressed: (){
                AuthService.signOutUser(context);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index){
              return itemOfPost(items[index]);
            },
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        onPressed: (){
          _callCreatePage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemOfPost(Post post){
    return Slidable(
      key: const ValueKey(null),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: (){},),
        children: [
          SlidableAction(
            onPressed: (BuildContext context){},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context){},
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: post.img_url != null ? Image.network(post.img_url!, fit: BoxFit.cover,) :
              Image.asset('assets/images/default-image.jpg'),
            ),
            const SizedBox(height: 15,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.firstname!, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),),
                const SizedBox(width: 10,),
                Text(post.lastname!, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),),
              ],
            ),
            const SizedBox(height: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.data!, style: const TextStyle(color: Colors.black, fontSize: 17),),
                const SizedBox(height: 5,),
                Text(post.content!, style: const TextStyle(color: Colors.black, fontSize: 17),),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
