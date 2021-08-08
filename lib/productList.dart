import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/cartDataType.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'showCart.dart';

class ProductList extends StatefulWidget {
  static var route = '/productList';

  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String cartString = "";
  List<CartPojo> cartList = [];
  late SharedPreferences prefs;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartList')!;
    cartList = CartPojo.decode(cartString);
    setState(() {
      count = cartList.length;
    });
  }

  Future<List<ProductPOJO>> _getProducts(String catId) async {
    var response = await post(
      Uri.parse('https://chickensmood.com/api/product.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "mobile_number": "none",
          "token": "none",
          "product_type": "none",
          "category_id": catId
        }
      ]),
    );
    var jsonData = json.decode(response.body);

    var listProducts = jsonData;

    List<ProductPOJO> products = [];

    var u = listProducts;

    for (int i = 0; i <= listProducts.length - 1; i++) {
      var name = u[i]['product_name'];
      var id = u[i]['product_id'];
      var pic = "https://chickensmood.com/api/" + u[i]['product_image'];
      var mrp = u[i]['mrp'];
      ProductPOJO user = ProductPOJO(id, name, pic, mrp);

      products.add(user);
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var categoryId = args.toString();

    return Scaffold(
      appBar: AppBar(title: Text('All courses'), actions: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              height: 150.0,
              width: 30.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ShowCart.route);
                },
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                    cartList.length == 0
                        ? Container()
                        : Positioned(
                            child: Stack(
                            children: <Widget>[
                              Icon(Icons.brightness_1,
                                  size: 20.0, color: Colors.green[800]),
                              Positioned(
                                  top: 3.0,
                                  right: 4.0,
                                  child: Center(
                                    child: Text(
                                      count.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ],
                          )),
                  ],
                ),
              )),
        )
      ]),
      body: Container(
        child: FutureBuilder(
          future: _getProducts(categoryId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: SpinKitCubeGrid(
                    color: Color(0xFFFF7801),
                    size: 50.0,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          onTap: () {
                            print(categoryId + " " + snapshot.data[index].id);
                          },
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(snapshot.data[index].avatar),
                          ),
                          title: Text(
                            snapshot.data[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹  " + snapshot.data[index].mrp,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  cartList.add(CartPojo(
                                      avatar: snapshot.data[index].avatar,
                                      category: categoryId,
                                      mrp: snapshot.data[index].mrp,
                                      name: snapshot.data[index].name,
                                      id: snapshot.data[index].id));

                                  prefs.setString(
                                      'cartList', CartPojo.encode(cartList));

                                  setState(() {
                                    count = cartList.length;
                                    Text('Remove');
                                  });

                                  Fluttertoast.showToast(
                                      msg: snapshot.data[index].name +
                                          "\nAdded to Cart",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 2);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductPOJO {
  final String id;
  final String name;
  final String avatar;
  final String mrp;

  ProductPOJO(this.id, this.name, this.avatar, this.mrp);
}
