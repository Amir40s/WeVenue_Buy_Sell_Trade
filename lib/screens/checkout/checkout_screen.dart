import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/custom_network_image.dart';
import 'package:biouwa/helper/payment.dart';
import 'package:biouwa/provider/cart/cart_provider.dart';
import 'package:biouwa/provider/check_out/check_out_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'order_placed_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String totalProducts;
  final String pPrice;

  const CheckoutScreen({
    super.key,
    required this.totalProducts,
    required this.pPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (!_formKey.currentState!.validate()) return;

    final paymentC = Get.put(PaymentController());
    final checkoutP = Provider.of<CheckOutP>(context, listen: false);
    final cartP = Provider.of<CartProvider>(context, listen: false);

    setState(() => _isProcessing = true);

    final fullAddress = _cityController.text.trim().isNotEmpty
        ? '${_addressController.text.trim()}, ${_cityController.text.trim()}'
        : _addressController.text.trim();

    paymentC.makePayment(
      amount: widget.pPrice,
      successMsj: 'Order placed successfully!',
      onSuccess: () {
        setState(() => _isProcessing = false);
        checkoutP.addOrder(
          address: fullAddress,
          userName: _nameController.text.trim(),
          userPhone: _phoneController.text.trim(),
          totalAmount: widget.pPrice,
          totalItems: widget.totalProducts,
        );
        cartP.clearCart();
        Get.off(() => const OrderPlacedScreen());
      },
    ).catchError((e) {
      setState(() => _isProcessing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartP = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          'Secure Checkout',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded, size: 13, color: Colors.green.shade700),
                const SizedBox(width: 4),
                Text(
                  'SSL Encrypted',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkout Stepper
                _buildStepper(),

                const SizedBox(height: 18),

                // Order Items Preview Accordion
                _buildOrderItemsPreview(cartP),

                const SizedBox(height: 18),

                // Shipping Details Card
                _buildShippingFormCard(),

                const SizedBox(height: 18),

                // Payment Method Card
                _buildPaymentMethodCard(),

                const SizedBox(height: 18),

                // Order Summary Breakdown
                _buildOrderCostSummary(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildBottomPayBar(),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _stepNode(1, 'Cart', isCompleted: true, isActive: false),
          _stepLine(isCompleted: true),
          _stepNode(2, 'Shipping', isCompleted: false, isActive: true),
          _stepLine(isCompleted: false),
          _stepNode(3, 'Payment', isCompleted: false, isActive: false),
        ],
      ),
    );
  }

  Widget _stepNode(int step, String label, {required bool isCompleted, required bool isActive}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : (isActive ? darkPurple : Colors.grey.shade200),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isActive ? darkPurple : (isCompleted ? Colors.black87 : Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _stepLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isCompleted ? Colors.green : Colors.grey.shade200,
      ),
    );
  }

  Widget _buildOrderItemsPreview(CartProvider cartP) {
    if (cartP.items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 18, color: darkPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Order Items (${cartP.itemCount})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${widget.pPrice} USD',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: darkPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: cartP.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = cartP.items[index];
                return Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        if (item.product.image.isNotEmpty)
                          CustomNetworkImage(
                            imageUrl: item.product.image,
                            width: 52,
                            height: 52,
                            fit: BoxFit.contain,
                          )
                        else
                          const Icon(Icons.image, size: 24, color: Colors.grey),
                        if (item.quantity > 1)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: darkPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
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
    );
  }

  Widget _buildShippingFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: darkPurple),
              SizedBox(width: 8),
              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Full Name
          _buildInputField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Recipient full name',
            icon: Icons.person_outline,
            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter recipient name' : null,
          ),

          const SizedBox(height: 14),

          // Phone Number
          _buildInputField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '+1 (555) 000-0000',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter contact phone number' : null,
          ),

          const SizedBox(height: 14),

          // Street Address
          _buildInputField(
            controller: _addressController,
            label: 'Street Address',
            hint: 'House / Apartment, Street Address',
            icon: Icons.home_outlined,
            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter shipping address' : null,
          ),

          const SizedBox(height: 14),

          // City / State / ZIP
          _buildInputField(
            controller: _cityController,
            label: 'City, State & ZIP',
            hint: 'e.g. New York, NY 10001',
            icon: Icons.map_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: darkPurple, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment_rounded, size: 20, color: darkPurple),
              SizedBox(width: 8),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: darkPurple.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: darkPurple.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.credit_card_rounded, color: darkPurple, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credit / Debit Card (Stripe)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Visa, Mastercard, Amex, Apple Pay, Google Pay',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: darkPurple, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCostSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Breakdown',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow('Items Subtotal', '\$${widget.pPrice}'),
          const SizedBox(height: 8),
          _summaryRow('Worldwide Shipping', 'FREE', isHighlight: true),
          const SizedBox(height: 8),
          _summaryRow('Taxes & Import Duty', 'Included', isHighlight: true),
          const Divider(height: 24),
          _summaryRow('Final Payable Amount', '\$${widget.pPrice} USD', isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isHighlight = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w900 : (isHighlight ? FontWeight.bold : FontWeight.w600),
            color: isTotal
                ? darkPurple
                : (isHighlight ? Colors.green.shade700 : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPayBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${widget.pPrice}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: darkPurple,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _processPayment,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.lock_outline, size: 18),
                label: Text(
                  _isProcessing ? 'Processing...' : 'Pay & Place Order',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPurple,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: darkPurple.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
