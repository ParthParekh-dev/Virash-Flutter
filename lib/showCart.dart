import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cartDataType.dart';

class ShowCart extends StatefulWidget {
  static var route = '/showCart';

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  String cartString = "";
  List<CartPojo> cartList = [];
  late SharedPreferences prefs;
  double cartTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    // WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartList')!;
    setState(() {
      cartList = CartPojo.decode(cartString);
    });

    calculateTotal();
  }

  calculateTotal() {
    var u = cartList;
    double total = 0.0;
    for (int i = 0; i <= cartList.length - 1; i++) {
      total = total + (double.parse(u[i].mrp));
    }
    setState(() {
      cartTotal = total;
    });
    print(cartTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          FlatButton(
            onPressed: () {
              setState(() {
                cartList = [];
              });
              prefs.setString('cartList', CartPojo.encode(cartList));
              calculateTotal();
            },
            child: Row(children: [
              Text("Clear All"),
              Icon(Icons.delete_forever),
            ]),
          )
        ],
      ),
      body: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: cartList.length,
            itemBuilder: (BuildContext context, int index) {
              if (cartList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Items in Cart'),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(cartList[index].avatar),
                        ),
                        title: Text(
                          cartList[index].name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹  " + cartList[index].mrp,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cartList.removeAt(index);
                                  calculateTotal();
                                  prefs.setString(
                                      'cartList', CartPojo.encode(cartList));
                                });
                              },
                              child: Text('Remove'),
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
              }
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total Amount : $cartTotal'),
                  ElevatedButton(
                    onPressed: () => {submitCart()},
                    child: Text('Proceed to Pay'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  submitCart() async {
    List checkoutList = [];
    var u = cartList;

    for (int i = 0; i <= cartList.length - 1; i++) {
      Map<String, String> map1 = {
        "product_id": u[i].id,
        "product_name": u[i].name,
        "quantity": "",
        "sale_rate": "",
        "mrp": u[i].mrp,
        "total": "",
        "delivery_note": "",
        "sub_total": "",
        "discount": "",
        "shipping_charges": "0",
        "order_amount": cartTotal.toString(),
        "expected_delivery": "",
        "geo_latitude": "",
        "geo_longitude": "",
        "geo_address": "",
        "payment_method": "Online",
        "user_id": prefs.getString('user_id').toString(),
        "mobile_number": prefs.getString('mobile').toString()
      };
      checkoutList.add(map1);
    }

    Response response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/saveOrder.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(checkoutList),
    );
    print(response.body);
  }
}
