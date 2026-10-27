import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/simple_header.dart';
import '../../provider/items/faq_provider.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  static const Color _background = Color(0xFFF7F8FA);
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _textColor = Color(0xFF202033);
  static const Color _mutedText = Color(0xFF85859A);
  static const Color _borderColor = Color(0xFFEEEEF4);

  @override
  Widget build(BuildContext context) {
    final faqs = Provider.of<FAQProvider>(
      context,
      listen: false,
    ).faqs;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              const SimpleHeader(),
              const SizedBox(height: 28),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find answers to common questions about our services.',
                style: TextStyle(
                  color: _mutedText,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: faqs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.help_outline_rounded,
                                color: primaryColor,
                                size: 38,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No FAQs available',
                              style: TextStyle(
                                color: _textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Please check back later.',
                              style: TextStyle(
                                color: _mutedText,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: faqs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final faq = faqs[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: _cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: darkPurple.withValues(alpha: 0.035),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor:
                                    primaryColor.withValues(alpha: 0.05),
                                highlightColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                childrenPadding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  18,
                                ),
                                iconColor: primaryColor,
                                collapsedIconColor: _mutedText,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                leading: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.help_outline_rounded,
                                    color: primaryColor,
                                    size: 21,
                                  ),
                                ),
                                title: Text(
                                  faq.question,
                                  style: const TextStyle(
                                    color: _textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 14),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: _borderColor,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      faq.answer,
                                      style: const TextStyle(
                                        color: _mutedText,
                                        fontSize: 13,
                                        height: 1.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
