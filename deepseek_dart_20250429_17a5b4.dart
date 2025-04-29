import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfitLossScreen extends StatelessWidget {
  const ProfitLossScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit & Loss'),
        backgroundColor: const Color(0xFF2A5C8D), // Dark blue from your palette
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Section
            _buildSectionHeader('Profit and Loss Overview'),
            const SizedBox(height: 16),
            
            // Stats Cards Row
            Row(
              children: [
                Expanded(child: _buildStatCard('5483', 'Total Product')),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('2000', 'Sales')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('10000', 'Total Stock')),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('508', 'Miss')),
              ],
            ),
            const SizedBox(height: 24),
            
            // Inventory Value Section
            _buildSectionHeader('Inventory Value'),
            const SizedBox(height: 16),
            _buildInventoryCard('30,000', 'Sales Return'),
            const SizedBox(height: 24),
            
            // Customer and Sales Section
            Row(
              children: [
                Expanded(child: _buildStatCard('100', "Today's customers")),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('4,000,000 DA', 'Total Sales')),
              ],
            ),
            const SizedBox(height: 24),
            
            // Actions Section
            _buildSectionHeader('Actions'),
            const SizedBox(height: 8),
            _buildActionButton('Log Damage', Icons.assignment_late),
            const SizedBox(height: 8),
            _buildActionButton('Alerts & Notification', Icons.notifications),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2A5C8D), // Dark blue
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50), // Green
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(String value, String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFF5F5F5), // Light gray background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Value',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600]),
                  ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A5C8D), // Dark blue
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add functionality here
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFC107), // Yellow
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}