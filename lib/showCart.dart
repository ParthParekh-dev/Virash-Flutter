import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/paymentSuccess.dart';
import 'package:flutter_virash/providers/cart_provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'cartDataType.dart';

class ShowCart extends StatefulWidget {
  static var route = '/showCart';

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  String cartString = "";
  late SharedPreferences prefs;
  // ignore: non_constant_identifier_names
  late String order_id;
  late Razorpay razorpay;
  Widget loginChild = PaymentButton();

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
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
      'amount': context.read<CartProvider>().cartTotal.toInt() * 100,
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
    context.read<CartProvider>().setCart(CartPojo.decode(cartString));
  }

  @override
  Widget build(BuildContext context) {
    final cartList = context.watch<CartProvider>().cartList;
    final cartTotal = context.watch<CartProvider>().cartTotal;
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
        appBar: AppBar(
          title: Text('Cart'),
          actions: cartList.length > 0
              ? [
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      Widget cancel = new TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                      Widget confirm = new TextButton(
                        child: Text("Clear"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<CartProvider>().clearCart();
                          prefs.setString(
                              'cartList', CartPojo.encode(cartList));
                        },
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          if (Platform.isAndroid) {
                            return AlertDialog(
                              title: Text("Are You Sure?"),
                              content: Text(
                                  "Would you like to remove all the items from your cart?"),
                              actions: [
                                cancel,
                                confirm,
                              ],
                            );
                          } else {
                            return CupertinoAlertDialog(
                              title: Text("Are You Sure?"),
                              content: Text(
                                  "Would you like to remove all the items from your cart?"),
                              actions: [
                                cancel,
                                confirm,
                              ],
                            );
                          }
                        },
                      );
                    },
                    child: Row(children: [
                      Text(
                        "Clear All",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ]),
                  )
                ]
              : [],
        ),
        body: cartList.length > 0
            ? Stack(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: cartList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(cartList[index].avatar),
                              ),
                              title: Text(
                                cartList[index].name,
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
                                    "₹  " + cartList[index].mrp,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  ElevatedButton(
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
                                              .removeFromCart(
                                                  cartList[index].id);
                                          prefs.setString('cartList',
                                              CartPojo.encode(cartList));
                                        },
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          if (Platform.isAndroid) {
                                            return AlertDialog(
                                              title: Text("Are You Sure?"),
                                              content: Text(
                                                  "Would you like to remove this item from your cart?"),
                                              actions: [
                                                cancel,
                                                confirm,
                                              ],
                                            );
                                          } else {
                                            return CupertinoAlertDialog(
                                              title: Text("Are You Sure?"),
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
              )
            : AnimationWidgets().noData,
      );
    }
  }

  submitCart() async {
    showLoader();
    List checkoutList = [];
    var u = context.read<CartProvider>().cartList;

    for (int i = 0; i <= u.length - 1; i++) {
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
        "order_amount": context.read<CartProvider>().cartTotal.toString(),
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
    } else {
      hideLoader();
      Fluttertoast.showToast(
          msg: "saveOrder.php != 200", toastLength: Toast.LENGTH_LONG);
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
          "amount": context.read<CartProvider>().cartTotal,
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
        child: SpinKitFadingCircle(
          color: Color(0xFF00008B),
          size: 50.0,
        ),
      ),
    );
  }
}
