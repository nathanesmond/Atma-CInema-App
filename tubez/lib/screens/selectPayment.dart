import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:tubez/widgets/MovieDetailWidgets/BackButton.dart';

class selectPaymentScreen extends StatefulWidget {
  const selectPaymentScreen(
      {super.key, required this.onPaymentSelected, required this.title});
  final String title;
  final Function(String) onPaymentSelected;

  @override
  State<selectPaymentScreen> createState() => _selectPaymentScreenState();
}

class _selectPaymentScreenState extends State<selectPaymentScreen> {
  // Variable to hold the selected payment method
  String? _selectedPaymentMethod;

  // List of payment methods with image paths and descriptions
  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'ShopeePay',
      'image': 'assets/images/shopeepay.png',
      'description':
          'Cashback s/d 10rb Koin Shopee untuk semua pengguna ShopeePay.'
    },
    {
      'name': 'Dana',
      'image': 'assets/images/dana.png',
      'description':
          'Dapatkan reward voucher Rp. 10.000 khusus transaksi pertama menggunakan DANA.'
    },
    {
      'name': 'OVO',
      'image': 'assets/images/ovo.png',
      'description':
          'Cashback s/d 20rb untuk transaksi pertama kamu pakai aplikasi OVO.'
    },
    {
      'name': 'Gojek',
      'image': 'assets/images/gojek.png',
      'description':
          'Cashback 50% maks. 50rb untuk transaksi pertama menggunakan Aplikasi GoPay.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    // Debugging step: Print out the list of payment methods and their descriptions
    paymentMethods.forEach((method) {
      print('Payment method: ${method['name']}');
      print('Description: ${method['description']}');
    });

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const Text(
          "Payment Method",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor:
            Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove the default shadow of the AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // E-Wallet Info Container
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 63, 62, 62),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "E-Wallet",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "Sebelum bertransaksi, pastikan metode pembayaran yang kamu pilih sudah tersedia di ponselmu ya!",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacer

                // Payment Method Options
                ...paymentMethods.map(
                  (method) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: RadioListTile<String>(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'] ?? 'Unknown', // Safe fallback
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Add a small gap
                            // Ensure description is being set correctly
                            Text(
                              method['description'] ??
                                  'No description available', // Safe fallback
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        value: method['name'] ?? '', // Safe fallback for value
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                            widget.onPaymentSelected(value ?? '');
                          });
                        },
                        activeColor:
                            Colors.amber, // Active color for the radio button
                        tileColor: Color.fromARGB(255, 63, 62, 62),
                        selectedTileColor: Color.fromARGB(255, 55, 54, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // Add trailing widget for the image
                        secondary: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(method['image'] ??
                                  ''), // Safe fallback for image
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
