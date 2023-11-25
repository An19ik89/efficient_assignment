import 'package:efficient_flutter_task/pages/feedback_page.dart';
import 'package:efficient_flutter_task/pages/order_page.dart';
import 'package:efficient_flutter_task/styles/text_styles.dart';
import 'package:efficient_flutter_task/widgets/buttons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: ButtonCustom(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderPage(),
                      ),
                    );
                  },
                  buttonName: const Text(
                    'Custom Order',
                    style: buttonMedium16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: ButtonCustom(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedBackPage(),
                      ),
                    );
                  },
                  buttonName: const Text(
                    'Feedback',
                    style: buttonMedium16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
