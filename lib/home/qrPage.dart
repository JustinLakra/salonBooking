import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Make sure to import the QR package
import 'package:salon/home/bookAnAppointmentPage.dart';
import 'package:salon/main.dart';

class PaymentPage extends StatefulWidget {
  final String slot;
  final String date;
  final String selectedService;
  final String gender;

  PaymentPage({
    required this.slot,
    required this.date,
    required this.selectedService,
    required this.gender,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: _buildPaymentContent(),
    );
  }

  Widget _buildPaymentContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // QR code image
        QrImageView(
          data: 'Your QR Code Data Here', // Replace with your actual data
          version: QrVersions.auto,
          size: 150,
        ),
        SizedBox(height: 16.0),
        // Pay button
        ElevatedButton(
          onPressed: () async {
            await confirmBooking();
            Navigator.of(context).pop();
            navigatorKey.currentState!.popUntil((route) => route.isFirst);
          },
          child: Text('Pay'),
        ),
      ],
    );
  }
