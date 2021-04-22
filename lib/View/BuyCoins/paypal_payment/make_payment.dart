import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/BuyCoins/paypal_payment/paypal_payment.dart';
import 'package:livu/theme.dart';

class MakePayment extends StatefulWidget {
  final String doctorName;
  final String cost;
  final String invoiceNo;
  final String date;
  final String time;
  final String doctorPhone;
  // final CurrentPatient currentPatient;
  MakePayment(
      {this.doctorName,
      this.cost,
      this.invoiceNo,
      this.date,
      this.time,
      this.doctorPhone});
  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  TextStyle style = TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: new AppBar(
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Paypal Payment',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans'),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    // make PayPal payment

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalPayment(
                            // onFinish: (number) async {
                            //   // payment done
                            //   print('order id: ' + number);
                            // },
                            // amount: '23',
                            // //currentPatient: widget.currentPatient,

                            // date: DateTime.now().toString(),
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Pay with Paypal',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                RaisedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => PaymentMethodScreen(
                    //         currentPatient: widget.currentPatient,
                    //         doctorName: widget.doctorName,
                    //         invoiceNo: widget.invoiceNo,
                    //         cost: widget.cost,
                    //         doctorPhone: widget.doctorPhone,
                    //         date: widget.date,
                    //         time: widget.time,
                    //       )),
                    // );
                  },
                  child: Text(
                    'Pay with Stripe',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
