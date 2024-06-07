// screens/faq_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';
import '../../helper/simple_header.dart';
import '../../helper/text_widget.dart';
import '../../provider/items/faq_provider.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faqs = Provider.of<FAQProvider>(context,listen: false).faqs;

    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SimpleHeader(),
                SizedBox(height: 40.0,),
                TextWidget(text: "Frequently Asked Questions", size: 22.0,color: Colors.black,isBold: true,),
                SizedBox(height: 40.0,),
                ListView.builder(
                  itemCount: faqs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final faq = faqs[index];
                    return ExpansionTile(
                      title: Text(faq.question),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(faq.answer),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
