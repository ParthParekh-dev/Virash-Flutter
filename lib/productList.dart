import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/cartDataType.dart';
import 'package:flutter_virash/productDetail.dart';
import 'package:flutter_virash/providers/cart_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animationWidgets.dart';
import 'showCart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';

class ProductList extends StatefulWidget {
  static var route = '/productList';

  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String cartString = "";
  late SharedPreferences prefs;
  var count = 0;

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
    _loadCounter();
  }

  _loadCounter() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartList')!;
    context.read<CartProvider>().setCart(CartPojo.decode(cartString));
  }

  Future<List<ProductPOJO>> _getProducts(String catId) async {
    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/product.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"exam_id": "1"}
      ]),
    );
    var jsonData = json.decode(response.body);

    var listProducts = jsonData;
    print(listProducts.length);

    List<ProductPOJO> products = [];

    var u = listProducts;

    for (int i = 0; i <= listProducts.length - 1; i++) {
      var name = u[i]['product_name'];
      var id = u[i]['product_id'].toString();
      var image = u[i]['product_image'].toString();
      var mrp = u[i]['mrp'].toString();
      ProductPOJO user = ProductPOJO(id, name, image, mrp);

      products.add(user);
    }

    count = products.length;

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var categoryId = args.toString();
    final cartList = context.watch<CartProvider>().cartList;
    bool isConnected = context.watch<InternetProvider>().isConnected;

    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationWidgets().noInternet,
        )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('All Products'), actions: <Widget>[
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
                      context.watch<CartProvider>().cartCount == 0
                          ? Container()
                          : Positioned(
                              child: Stack(
                              children: <Widget>[
                                Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.blue[800]),
                                Positioned(
                                    top: 2.0,
                                    right: 7.0,
                                    child: Center(
                                      child: Text(
                                        context
                                            .watch<CartProvider>()
                                            .cartCount
                                            .toString(),
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
                if (count == 0) {
                  return AnimationWidgets().noData;
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
                                Navigator.pushNamed(
                                    context, ProductDetail.route, arguments: [
                                  snapshot.data[index].id,
                                  snapshot.data[index].name
                                ]);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "₹  " + snapshot.data[index].mrp,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  cartList
                                          .map((e) => e.id)
                                          .contains(snapshot.data[index].id)
                                      ? ElevatedButton(
                                          child: Text("Remove"),
                                          onPressed: () {
                                            Widget cancel = new TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                            Widget confirm = new TextButton(
                                              child: Text("Remove"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context
                                                    .read<CartProvider>()
                                                    .removeFromCart(snapshot
                                                        .data[index].id);
                                                prefs.setString('cartList',
                                                    CartPojo.encode(cartList));

                                                Fluttertoast.showToast(
                                                    msg: snapshot
                                                            .data[index].name +
                                                        "\nRemoved from Cart",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.SNACKBAR,
                                                    timeInSecForIosWeb: 2);
                                              },
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                if (Platform.isAndroid) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Are You Sure?"),
                                                    content: Text(
                                                        "Would you like to remove this item from your cart?"),
                                                    actions: [
                                                      cancel,
                                                      confirm,
                                                    ],
                                                  );
                                                } else {
                                                  return CupertinoAlertDialog(
                                                    title:
                                                        Text("Are You Sure?"),
                                                    content: Text(
                                                        "Would you like to remove this item from your cart?"),
                                                    actions: [
                                                      cancel,
                                                      confirm,
                                                    ],
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        )
                                      : ElevatedButton(
                                          child: Text("Add To Cart"),
                                          onPressed: () {
                                            context
                                                .read<CartProvider>()
                                                .addToCart(CartPojo(
                                                    avatar: snapshot
                                                        .data[index].avatar,
                                                    category: categoryId,
                                                    mrp: snapshot
                                                        .data[index].mrp,
                                                    name: snapshot
                                                        .data[index].name,
                                                    id: snapshot
                                                        .data[index].id));

                                            print(cartList);

                                            prefs.setString('cartList',
                                                CartPojo.encode(cartList));

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
              }
            },
          ),
        ),
      );
    }
  }
}

class ProductPOJO {
  final String id;
  final String name;
  final String avatar;
  final String mrp;

  ProductPOJO(this.id, this.name, this.avatar, this.mrp);
}
