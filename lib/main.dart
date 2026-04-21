import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:payment_app/screens/product_page.dart";

Future<void> main() async {
  await dotenv.load();

  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Payment App",
      theme: ThemeData.dark(useMaterial3: true),
      home: const ProductPage(),
    );
  }
}