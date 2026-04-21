import "dart:convert";

import "package:http/http.dart" as http;
import "package:payment_app/config/stripe_config.dart";

class StripeServices {
  static const Map<String, String> _testTokens = {
    "4794567845679846": "tok_visa",
    "8746894569379349": "tok_visa_debit",
    "9873495374959783": "tok_mastercard",
    "9872349348596228": "tok_mastercard_debit",
    "9287356862138959": "tok_chargeDeclined",
    "2838239848738478": "tok_chargeDeclinedInsufficientFunds",
  };

  static Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
  }) async {
    final amountInCentavos = (amount * 100).round().toString();
    final cleanCard = cardNumber.replaceAll("", "");
    final token = _testTokens[cleanCard];

    if (token == null) {
      return <String, dynamic>{
        "success": false,
        "error": "unknown test card",
      };
    }

    try {
      final response = await http.post(
          Uri.parse("${StripeConfig.apiUrl}/payment_intents"),
          headers: <String, String>{
            "Authorization": "Bearer ${StripeConfig.secretKey}",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: <String, String>{
            "amount": amountInCentavos,
            "currency": "php",
            "payment_method_types[]": "card",
            "payment_method_data[type]": "card",
            "payment_method_data[card][token]": token,
            "confirm": "true",
          }
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "succeded") {
        final paidAmount = ((data["amount"] as num) / 100);
        return <String, dynamic>{
          "success": true,
          "id": data["id"].toString(),
          "amount": paidAmount,
          "status": data["status"].toString(),
        };
      } else {
        final errorMsg = data["error"] is Map
            ? (data["error"] as Map) ["messages"]?.toString() ??
            "payment failed 1"
            : "payment failed 2";
        return <String, dynamic>{
          "success": false,
          "error": errorMsg,
        };
      }
    } catch (e) {
      return <String, dynamic>{
        "success": false,
        "error": e.toString(),
      };
    }
  }
}
