import "package:flutter_dotenv/flutter_dotenv.dart";

class StripeConfig {
  static final publishableKey = dotenv.env["PUBLISHABLE_KEY"]!;
  static final secretKey = dotenv.env["SECRET_KEY"]!;

  static const String apiUrl = "https://api.stripe.com/v1";
}