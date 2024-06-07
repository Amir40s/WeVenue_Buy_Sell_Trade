// providers/faq_provider.dart
import 'package:flutter/material.dart';

import '../../model/faq/faq_model.dart';

class FAQProvider extends ChangeNotifier {
  final List<FAQ> _faqs = [
    FAQ(
      question: "How do I list an item for sale?",
      answer: "To list an item for sale, go to the 'Sell' section, provide item details, set your price, and submit your listing.",
    ),
    FAQ(
      question: "How can I edit my listing?",
      answer: "To edit your listing, go to 'My Listings', select the item, and click on 'Edit'. Make the necessary changes and save.",
    ),
    FAQ(
      question: "What should I do if my item doesn't sell?",
      answer: "You can try adjusting the price, improving the description, or adding better photos. If it still doesn't sell, consider other platforms.",
    ),
    FAQ(
      question: "How can I ensure my purchase is safe?",
      answer: "Ensure you communicate only through the platform, avoid sharing personal information, and review seller ratings before purchasing.",
    ),
    FAQ(
      question: "What payment methods are accepted?",
      answer: "Accepted payment methods include credit/debit cards, PayPal, and other supported payment gateways available in the checkout process.",
    ),
  ];

  List<FAQ> get faqs => _faqs;
}
