import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chai Suta bar ',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ChaiShopBillingScreen(),
    );
  }
}

class ChaiShopBillingScreen extends StatefulWidget {
  @override
  _ChaiShopBillingScreenState createState() => _ChaiShopBillingScreenState();
}

class _ChaiShopBillingScreenState extends State<ChaiShopBillingScreen> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _chaiCountController = TextEditingController();
  int _totalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chai Shop Billing System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number or UPI ID',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _chaiCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Chai Orders',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                sendPaymentRequest();
              },
              child: Text('Send Payment Request'),
            ),
            SizedBox(height: 16.0),
            Text('Total Amount: $_totalAmount Rs'),
          ],
        ),
      ),
    );
  }

  void calculateTotalAmount() {
    int chaiCount = int.tryParse(_chaiCountController.text) ?? 0;
    setState(() {
      _totalAmount = chaiCount * 10;
    });
  }

  void sendPaymentRequest() async {
    calculateTotalAmount();
    String mobileNumber = _mobileNumberController.text;
    if (mobileNumber.isNotEmpty) {
      String upiLink =
          'upi://pay?pa=$mobileNumber&am=$_totalAmount&pn=ChaiShop&cu=INR';
      if (await canLaunch(upiLink)) {
        await launch(upiLink);
      } else {
        _showSnackBar('Could not launch payment app');
      }
    } else {
      _showSnackBar('Please enter a mobile number or UPI ID');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _chaiCountController.dispose();
    super.dispose();
  }
}
