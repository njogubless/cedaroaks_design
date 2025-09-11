import 'package:cedaroaks_design/screens/loading_screen.dart';
import 'package:cedaroaks_design/screens/reg_sucess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Payment Details Screen
class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Mary Etim lkott');
  final _cardNumberController = TextEditingController(text: '4173 1234 5106 0922');
  final _expiryController = TextEditingController(text: '01/26');
  final _cvvController = TextEditingController(text: '123');
  final _billingController = TextEditingController(text: 'marykayla@gmail.com');
  
  bool _rememberCard = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _billingController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    // Remove all spaces
    value = value.replaceAll(' ', '');
    // Add space every 4 characters
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String _formatExpiry(String value) {
    // Remove all non-digits
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length >= 2) {
      value = '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  Widget _getCardIcon() {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 2,
            top: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1A1A1A), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Registration fee',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Card details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Please provide your payment details below. A one-time registration fee of 2000 naira will be charged to your card.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32),
                
                // Name on Card
                _buildFormField(
                  label: 'Name on card',
                  controller: _nameController,
                  hintText: 'Enter name on card',
                ),
                SizedBox(height: 24),
                
                // Card Number
                _buildCardNumberField(),
                SizedBox(height: 24),
                
                // Expiry Date and CVV Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: 'Expiry Date',
                        controller: _expiryController,
                        hintText: 'MM/YY',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            return TextEditingValue(
                              text: _formatExpiry(newValue.text),
                              selection: TextSelection.collapsed(
                                offset: _formatExpiry(newValue.text).length,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        label: 'CVV',
                        controller: _cvvController,
                        hintText: '123',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Remember Card Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _rememberCard,
                        onChanged: (value) {
                          setState(() {
                            _rememberCard = value ?? false;
                          });
                        },
                        activeColor: Color(0xFF4F7DF8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Remember this card for monthly auto charges',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Billing Address
                _buildFormField(
                  label: 'Billing Address',
                  controller: _billingController,
                  hintText: 'Enter billing address',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                
                // Why Registration Fee Link
                GestureDetector(
                  onTap: () {
                    _showRegistrationFeeDialog();
                  },
                  child: Text(
                    'Why a Registration fee?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4F7DF8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                
                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4F7DF8),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 52,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4F7DF8), width: 1.5),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Number',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 52,
          child: TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return TextEditingValue(
                  text: _formatCardNumber(newValue.text),
                  selection: TextSelection.collapsed(
                    offset: _formatCardNumber(newValue.text).length,
                  ),
                );
              }),
            ],
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
            decoration: InputDecoration(
              hintText: '1234 5678 9012 3456',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4F7DF8), width: 1.5),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(14),
                child: _getCardIcon(),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Card number is required';
              }
              if (value.replaceAll(' ', '').length < 16) {
                return 'Card number must be 16 digits';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _showRegistrationFeeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Fee'),
          content: Text(
            'The registration fee helps us maintain our platform and provide you with the best service. This is a one-time payment that ensures your account setup and verification.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it', style: TextStyle(color: Color(0xFF4F7DF8))),
            ),
          ],
        );
      },
    );
  }

  void _handleProceed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Navigate to loading screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      // Simulate payment processing
      await Future.delayed(Duration(seconds: 3));
      
      setState(() {
        _isLoading = false;
      });

      // Navigate to success screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegistrationSuccessScreen()),
        );
      }
    }
  }
}


