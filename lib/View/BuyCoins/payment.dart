import 'package:flutter/material.dart';
import 'package:livu/Services/Payment_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:livu/theme.dart';
import 'package:livu/Services/CoinsDeduction.dart';
import 'package:get/get.dart';
class Payment extends StatefulWidget {
  int coins;
  int finalAmount;
  Payment({Key key, this.finalAmount, this.coins}) : super(key: key);

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    print(widget.finalAmount);
    final ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: widget.finalAmount.toString(), currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    if(response.success){
      CoinsDeduction().addCoins(widget.coins);
      Future.delayed(Duration(seconds: 2),(){
        Get.back();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.finalAmount);
    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: greyColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: Colors.white);
                  text = Text(
                    'Pay via new card',
                    style: TextStyle(color: Colors.white),
                  );
                  break;
                // case 1:
                //   icon = Icon(Icons.credit_card, color: theme.primaryColor);
                //   text = Text('Pay via existing card');
                //   break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
            itemCount: 1),
      ),
    );
    ;
  }
}
