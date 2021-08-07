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
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartList')!;
    cartList = CartPojo.decode(cartString);

    for (var u in cartList) {
      print(u.name);
    }
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: () {},
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
                          // cartList.add(CartPojo(
                          //     avatar: snapshot.data[index].avatar,
                          //     category: categoryId,
                          //     mrp: snapshot.data[index].mrp,
                          //     name: snapshot.data[index].name,
                          //     id: snapshot.data[index].id));
                          //
                          // prefs.setString(
                          //     'cartList', CartPojo.encode(cartList));
                          //
                          // print(cartList);
                        },
                        child: Text('Add to Cart'),
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
        },
      ),
    );
  }
}
