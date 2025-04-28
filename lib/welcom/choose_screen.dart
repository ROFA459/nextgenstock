import 'package:flutter/material.dart';
import 'package:next/stock/stock_home_screen.dart';
import 'package:next/sale softwer/sales_home.dart'; // Make sure to create this file

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  // Modern color palette
  static const Color _primaryColor = Color(0xFF6C63FF); // Vibrant purple
  static const Color _secondaryColor = Color(0xFF4D8DEE); // Soft blue
  static const Color _surfaceColor = Colors.white;
  static const Color _textColor = Color(0xFF2D3748); // Dark gray
  static const Color _errorColor = Color(0xFFFF5252); // Red

  Future<void> _showPasswordDialog(BuildContext context) async {
    final passwordController = TextEditingController();
    const correctPassword = "admin123"; // Replace with secure storage in production

    return showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: Dialog(
            insetPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: _primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Stock Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your password to continue',
                      style: TextStyle(
                        color: _textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        hintText: 'Password',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (passwordController.text == correctPassword) {
                                Navigator.pop(context);
                                _navigateToStockScreen(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Incorrect password'),
                                    backgroundColor: _errorColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.only(
                                      bottom: 20,
                                      left: 16,
                                      right: 16,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: _surfaceColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToStockScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const StockHomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _navigateToSalesScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SalesHomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildChoiceCard({
    required String imagePath,
    required String title,
    required Color buttonColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Stack(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 280,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: _buildChoiceCard(
              imagePath: 'assets/image/2.png',
              title: 'Sales Software',
              buttonColor: _surfaceColor,
              textColor: _textColor,
              onPressed: () => _navigateToSalesScreen(context),
            ),
          ),
          Expanded(
            child: _buildChoiceCard(
              imagePath: 'assets/image/1.png',
              title: 'Stock Management',
              buttonColor: _primaryColor,
              textColor: _surfaceColor,
              onPressed: () => _showPasswordDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}