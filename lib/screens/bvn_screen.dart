// BVN Screen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BvnScreen extends StatefulWidget {
  const BvnScreen({super.key});

  @override
  _BVNScreenState createState() => _BVNScreenState();
}

class _BVNScreenState extends State<BvnScreen> {
  final _bvnController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _bvnController.dispose();
    super.dispose();
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
          'BVN',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Color(0xFFF0F0F0),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'You need to verify your BVN to gain full access to the app',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Enter your 10 digits Bank Verification Number',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BVN',
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
                      controller: _bvnController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your BVN',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'BVN is required';
                        }
                        if (value.length != 10) {
                          return 'BVN must be exactly 10 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 52,
                margin: EdgeInsets.only(bottom: 32),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle BVN verification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('BVN verification initiated'),
                          backgroundColor: Color(0xFF22C55E),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F7DF8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Verify BVN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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