import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/paymentSuccess.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  late String order_id;
  late Razorpay razorpay;
  Widget loginChild = PaymentButton();

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _loadCounter();
  }

  void showLoader() {
    setState(() {
      loginChild = Spinner();
    });
  }

  void hideLoader() {
    setState(() {
      loginChild = PaymentButton();
    });
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openRazorpay() {
    var options = {
      'key': 'rzp_test_qSWt4ArR6JPRSE',
      'amount': cartTotal.toInt() * 100,
      'name': 'Unique',
      'description': 'Commerce Courses',
      'prefill': {
        'contact': prefs.getString('mobile').toString(),
        'email': prefs.getString('email').toString()
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_LONG);
    paymentFinal(response.paymentId!.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
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
      body: Stack(
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
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Total Amount : $cartTotal'),
                        GestureDetector(
                          onTap: () {
                            submitCart();
                          },
                          child: loginChild,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  submitCart() async {
    showLoader();
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
    if (response.statusCode == 200) {
      var success = (json.decode(response.body)[0]['success']).toString();
      order_id = (json.decode(response.body)[0]['order_id']).toString();
      if (success == "1") {
        hideLoader();
        openRazorpay();
      }
    }
  }

  paymentFinal(String paymentId) async {
    showLoader();
    Response response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/payment.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "pg_payment_id": paymentId,
          "amount": cartTotal,
          "payment_status": "Success",
          "amount_status": "Paid",
          "mode_of_payment": "Online",
          "mobile_number": prefs.getString('mobile'),
          "order_id": order_id,
          "email": prefs.getString('email')
        }
      ]),
    );
    if (response.statusCode == 200) {
      print(response.body);
      prefs.setString('cartList', CartPojo.encode([]));
      hideLoader();
      Navigator.pushNamedAndRemoveUntil(
          context, PaymentSuccess.route, (r) => false);
    } else {
      Fluttertoast.showToast(
          msg: "Payment.php != 200", toastLength: Toast.LENGTH_LONG);
      hideLoader();
    }
  }
}

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        "Proceed to Payment",
        style: TextStyle(color: Colors.white),
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
        child: SpinKitCubeGrid(
          color: Color(0xFFFF7801),
          size: 50.0,
        ),
      ),
    );
  }
}
