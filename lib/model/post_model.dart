class Post {
  String? firstname;
  String? lastname;
  String? data;
  String? content;
  String? img_url;
  String? userId;

  Post({this.firstname, this.lastname, this.data, this.content, this.img_url, this.userId});

  Post.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        data = json['data'],
        content = json['content'],
        img_url = json['img_url'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
    'data': data,
    'content': content,
    'img_url': img_url,
    'userId': userId,
  };
}