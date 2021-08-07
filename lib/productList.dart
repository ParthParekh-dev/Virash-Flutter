import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class ProductList extends StatefulWidget {
  static var route = '/productList';

  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('All courses'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getProducts(args.toString()),
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
                            Navigator.pushNamed(context, ProductList.route,
                                arguments: snapshot.data[index].id);
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
                          subtitle: Text(
                            "₹  " + snapshot.data[index].mrp,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        child: Divider(
                          thickness: 3,
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
