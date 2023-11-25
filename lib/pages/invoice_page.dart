import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

class InvoicePage extends StatefulWidget {

  Map<String, dynamic> formDataForStore = {};

  InvoicePage({super.key,required this.formDataForStore});


  @override
  _InvoicePageState createState() => _InvoicePageState(formDataForStore);
}

class _InvoicePageState extends State<InvoicePage> {
  Map<String, dynamic> invoiceData = {};

  _InvoicePageState(this.invoiceData);

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display invoice details
            const Text('Invoice Details:'),
            for (var entry in invoiceData.entries)
              Text('${entry.key}: ${entry.value}'),
            const SizedBox(height: 20),

            // Save and Send Email buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _saveInvoiceToStorage(context),
                  child: const Text('Save Invoice'),
                ),
                ElevatedButton(
                  onPressed: () => _sendEmail(context),
                  child: const Text('Send Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveInvoiceToStorage(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/invoice.json');
      await file.writeAsString(jsonEncode(invoiceData));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved to storage')),
      );
    } catch (e) {
      print('Error saving invoice: $e');
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Email email = Email(
      body: 'Invoice Details:\n${jsonEncode(invoiceData)}',
      subject: 'Invoice',
      recipients: ['customer@example.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent successfully')),
      );
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}