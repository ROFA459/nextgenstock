import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesHomeScreen extends StatefulWidget {
  const SalesHomeScreen({super.key});

  @override
  State<SalesHomeScreen> createState() => _SalesHomeScreenState();
}

class _SalesHomeScreenState extends State<SalesHomeScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _cartItems = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Favorite products (quick access items)
  final List<Map<String, dynamic>> _favoriteProducts = [
    {
      'id': '1',
      'name': 'Lentils',
      'price': 2.50,
      'color': const Color(0xFFF9A825),
      'barcode': '123456',
      'icon': Icons.grain,
    },
    {
      'id': '2',
      'name': 'Flour',
      'price': 1.80,
      'color': const Color(0xFF6D4C41),
      'barcode': '789012',
      'icon': Icons.cookie,
    },
    {
      'id': '3',
      'name': 'Olives',
      'price': 3.20,
      'color': const Color(0xFF2E7D32),
      'barcode': '345678',
      'icon': Icons.eco,
    },
    {
      'id': '4',
      'name': 'Cheese',
      'price': 4.50,
      'color': const Color(0xFFFDD835),
      'barcode': '901234',
      'icon': Icons.lunch_dining,
    },
  ];

  final List<Map<String, dynamic>> _availableProducts = [
    {'id': '1', 'name': 'Lentils Bean', 'barcode': '123456', 'price': 2.50, 'stock': 10},
    {'id': '2', 'name': 'Flour Whole wheat', 'barcode': '789012', 'price': 1.80, 'stock': 15},
    {'id': '3', 'name': 'Olive Pickles', 'barcode': '345678', 'price': 3.20, 'stock': 8},
    {'id': '4', 'name': 'Cashir Cheese', 'barcode': '901234', 'price': 4.50, 'stock': 5},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  double get _totalPrice => _cartItems.fold(
      0, (sum, item) => sum + (item['price'] * item['quantity']));

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);
      if (existingIndex >= 0) {
        _cartItems[existingIndex]['quantity'] += 1;
      } else {
        _cartItems.add({
          ...product,
          'quantity': 1,
          'total': product['price'],
        });
      }
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == productId);
    });
  }

  void _updateQuantity(String productId, int newQuantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item['id'] == productId);
      if (index >= 0) {
        _cartItems[index]['quantity'] = newQuantity;
        _cartItems[index]['total'] = _cartItems[index]['price'] * newQuantity;
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  Widget _buildActionButton(String text, {Color? color, IconData? icon, VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _handleBarcodeScan() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      final barcode = _searchController.text.trim().isEmpty
          ? '123456' // Default barcode if search is empty
          : _searchController.text.trim();

      final product = _availableProducts.firstWhere(
            (p) => p['barcode'] == barcode,
        orElse: () => {},
      );

      if (product.isNotEmpty) {
        _addToCart(product);
        _showSnackBar('Added ${product['name']} to cart');
      } else {
        _showSnackBar('Product not found', isError: true);
      }
    } catch (e) {
      _showSnackBar('Scan failed: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  DataRow _buildProductRow(Map<String, dynamic> item) {  // Changed return type to DataRow
    return DataRow(
      cells: [
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeFromCart(item['id']),
            iconSize: 20,
          ),
        ),
        DataCell(Text(item['name'], style: const TextStyle(fontSize: 14))),
        DataCell(Text('${item['price'].toStringAsFixed(2)} DA', style: const TextStyle(fontSize: 14))),
        DataCell(
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: () {
                    if (item['quantity'] > 1) {
                      _updateQuantity(item['id'], item['quantity'] - 1);
                    }
                  },
                ),
                Text(item['quantity'].toString(), style: const TextStyle(fontSize: 14)),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () {
                    _updateQuantity(item['id'], item['quantity'] + 1);
                  },
                ),
              ],
            ),
          ),
        ),
        DataCell(Text('${(item['price'] * item['quantity']).toStringAsFixed(2)} DA',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.point_of_sale, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Text('NextGenStock', style: TextStyle(fontSize: 20)),
          ],
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formattedTime, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              _buildActionButton(
                'Stock',
                icon: Icons.inventory,
                onPressed: () => Navigator.pop(context),
                color: Colors.green[700],
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          // Left menu with favorite products
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(right: BorderSide(color: Colors.grey[200]!)),
            ),
            child: ListView.builder(
              itemCount: _favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = _favoriteProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: product['name'],
                    child: InkWell(
                      onTap: () => _addToCart(product),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: product['color'],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(product['icon'], color: Colors.white, size: 30),
                            const SizedBox(height: 8),
                            Text(
                              product['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main content area
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchBar(
                      controller: _searchController,
                      hintText: 'Search product or scan barcode...',
                      leading: const Icon(Icons.search),
                      trailing: [
                        IconButton(
                          icon: const Icon(Icons.barcode_reader),
                          onPressed: _handleBarcodeScan,
                          tooltip: 'Scan barcode',
                        ),
                      ],
                      onChanged: (value) => setState(() {}),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_totalPrice.toStringAsFixed(2)} DA',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) => Colors.blue[50],
                            ),
                            columns: const [
                              DataColumn(label: SizedBox(width: 40)),
                              DataColumn(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: _cartItems.map((item) => _buildProductRow(item)).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                        Text(
                          formattedTime,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildActionButton('Modify Price', icon: Icons.edit),
                        _buildActionButton('Modify Qty', icon: Icons.numbers),
                        _buildActionButton('Ticket', icon: Icons.receipt),
                        _buildActionButton('Print', icon: Icons.print),
                        _buildActionButton('Search', icon: Icons.search),
                        _buildActionButton('Return', icon: Icons.keyboard_return),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('06.00% Tax', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        _buildActionButton('Delete', color: Colors.red[700], icon: Icons.delete),
                        const SizedBox(width: 8),
                        _buildActionButton('Cancel', color: Colors.orange[700], icon: Icons.cancel),
                        const SizedBox(width: 8),
                        _buildActionButton('Promo', color: Colors.green[700], icon: Icons.local_offer),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}