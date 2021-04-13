import 'package:stripe_payment/stripe_payment.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51IfN7mAkfqBrrBoH77eWxQ8OtLQ6OQwdNOsLskf0xU3X53y1S5tzKmPLHbqBIs90Q45vkQz4jW62Lxxe0fB3x7gI00exwMH4M6';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51IfN7mAkfqBrrBoHIS7nsitKcF8wbN9aKs2Ie3jrWdiCRreAztZsppprmA3RHBmFvt6wW1kvsnPgMrWkC9WDSHEm0023jcNtbH",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  // static Future<StripeTransactionResponse> payViaExistingCard(
  //     {String amount, String currency, CreditCard card}) async {
  //   try {
  //     var paymentMethod = await StripePayment.createPaymentMethod(
  //         PaymentMethodRequest(card: card));
  //     var paymentIntent =
  //         await StripeService.createPaymentIntent(amount, currency);
  //     var a = paymentIntent['client_secret'].toString().split("_");
  //     print("my new client id is:${a[0] + '_' + a[1]}");
  //     var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
  //         clientSecret: paymentIntent['client_secret'],
  //         paymentMethodId: paymentMethod.id));
  //     print(paymentIntent['client_secret']);

  //     if (response.status == 'succeeded') {
  //       return new StripeTransactionResponse(
  //           message: 'Transaction successful', success: true);
  //     } else {
  //       return new StripeTransactionResponse(
  //           message: 'Transaction failed', success: false);
  //     }
  //   } on PlatformException catch (err) {
  //     return StripeService.getPlatformExceptionErrorResult(err);
  //   } catch (err) {
  //     return new StripeTransactionResponse(
  //         message: 'Transaction failed: ${err.toString()}', success: false);
  //   }
  // }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    print(amount);
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      print(paymentMethod.billingDetails);
      print(paymentMethod.card);
      print(paymentMethod.id);
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      print(paymentIntent);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
