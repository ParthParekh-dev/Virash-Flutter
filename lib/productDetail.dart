import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'homePage.dart';

class ProductDetail extends StatefulWidget {
  static var route = '/productDetail';

  const ProductDetail({Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var examName = "";
  var productName = "";
  var mrp = "";
  var image = "";
  var description = "";
  var product_id = "";
  var product_name = "";
  bool loading = true;
  late var args;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as List;
      });
      getProductDetails(args[0].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    product_id = args[0].toString();
    product_name = args[1].toString();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(product_name),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomePage.route, (r) => false);
              },
              icon: Icon(Icons.home),
            ),
          ],
        ),
        body: Container(
          child: (loading)
              ? Spinner()
              : ProductDesc(examName, productName, mrp, image, description),
        ),
      ),
    );
  }

  Future<void> getProductDetails(String id) async {
    Response response = await get(
      Uri.parse(
          'https://virashtechnologies.com/unique/api/getProductDetail.php?product_id=' +
              id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var result = jsonDecode(response.body)[0];

    setState(() {
      examName = result['exam_name'];
      productName = result['product_name'];
      mrp = result['mrp'];
      image = result['product_image'];
      description = result['description'];
      loading = false;
    });
  }
}

class ProductDesc extends StatelessWidget {
  final String image;
  final String examName;
  final String productName;
  final String description;
  final String mrp;

  ProductDesc(
      this.examName, this.productName, this.mrp, this.image, this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Center(
            child: Text(
              examName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            productName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 20,
              child: Image.network(
                "https://virashtechnologies.com/unique/img/slider/slider_1630441324.jpg",
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(description),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "₹ " + mrp,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 25.0,
        ),
      ),
    );
  }
}
