import 'package:flutter/material.dart';
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
    print(cartList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
