class Post {
  String? firstname;
  String? lastname;
  String? data;
  String? content;
  String? userId;

  Post({this.firstname, this.lastname, this.data, this.content, this.userId});

  Post.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        data = json['data'],
        content = json['content'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
    'data': data,
    'content': content,
    'userId': userId,
  };
}