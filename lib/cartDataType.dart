import 'dart:convert';

class CartPojo {
  final String category;
  final String id;
  final String name;
  final String avatar;
  final String mrp;

  CartPojo(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.mrp,
      required this.category});

  factory CartPojo.fromJson(Map<String, dynamic> jsonData) {
    return CartPojo(
        id: jsonData['id'],
        name: jsonData['name'],
        avatar: jsonData['avatar'],
        mrp: jsonData['mrp'],
        category: jsonData['category']);
  }

  static Map<String, dynamic> toMap(CartPojo cartPojo) => {
        'id': cartPojo.id,
        'name': cartPojo.name,
        'avatar': cartPojo.avatar,
        'mrp': cartPojo.mrp,
        'category': cartPojo.category,
      };

  static String encode(List<CartPojo> cartPojos) => json.encode(
        cartPojos
            .map<Map<String, dynamic>>((cartPojo) => CartPojo.toMap(cartPojo))
            .toList(),
      );

  static List<CartPojo> decode(String cartPojos) =>
      (json.decode(cartPojos) as List<dynamic>)
          .map<CartPojo>((item) => CartPojo.fromJson(item))
          .toList();
}
