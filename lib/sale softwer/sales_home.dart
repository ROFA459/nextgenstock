import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'stock_home_screen.dart'; // Make sure to import your stock management screen

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
  String? _selectedProductId;

  // Color palette from the image
  final Color _primaryColor = const Color(0xFF2A5C8D);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _accentColor = const Color(0xFFFFC107);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _textColor = const Color(0xFF333333);
  final Color _errorColor = const Color(0xFFE53935);

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
    {
      'id': '5',
      'name': 'Rice',
      'price': 1.50,
      'color': const Color(0xFF795548),
      'barcode': '567890',
      'icon': Icons.rice_bowl,
    },
    {
      'id': '6',
      'name': 'Oil',
      'price': 3.80,
      'color': const Color(0xFFFBC02D),
      'barcode': '234567',
      'icon': Icons.water_drop,
    },
    {
      'id': '7',
      'name': 'Sugar',
      'price': 1.20,
      'color': const Color(0xFFE0E0E0),
      'barcode': '890123',
      'icon': Icons.cake,
    },
    {
      'id': '8',
      'name': 'Pasta',
      'price': 2.00,
      'color': const Color(0xFFD7CCC8),
      'barcode': '456789',
      'icon': Icons.dinner_dining,
    },
  ];

  final List<Map<String, dynamic>> _availableProducts = [
    {'id': '1', 'name': 'Lentils Bean', 'barcode': '123456', 'price': 2.50, 'stock': 10},
    {'id': '2', 'name': 'Flour Whole wheat', 'barcode': '789012', 'price': 1.80, 'stock': 15},
    {'id': '3', 'name': 'Olive Pickles', 'barcode': '345678', 'price': 3.20, 'stock': 8},
    {'id': '4', 'name': 'Cashir Cheese', 'barcode': '901234', 'price': 4.50, 'stock': 5},
    {'id': '5', 'name': 'Basmati Rice', 'barcode': '567890', 'price': 1.50, 'stock': 20},
    {'id': '6', 'name': 'Olive Oil', 'barcode': '234567', 'price': 3.80, 'stock': 12},
    {'id': '7', 'name': 'White Sugar', 'barcode': '890123', 'price': 1.20, 'stock': 25},
    {'id': '8', 'name': 'Spaghetti', 'barcode': '456789', 'price': 2.00, 'stock': 18},
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
      _selectedProductId = product['id'];
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == productId);
      if (_selectedProductId == productId) {
        _selectedProductId = null;
      }
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

  void _updatePrice(String productId, double newPrice) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item['id'] == productId);
      if (index >= 0) {
        _cartItems[index]['price'] = newPrice;
        _cartItems[index]['total'] = newPrice * _cartItems[index]['quantity'];
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
        backgroundColor: color ?? _primaryColor,
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
        backgroundColor: isError ? _errorColor : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  DataRow _buildProductRow(Map<String, dynamic> item) {
    final isSelected = _selectedProductId == item['id'];
    return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        setState(() {
          _selectedProductId = selected! ? item['id'] : null;
        });
      },
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

  void _showPriceDialog() {
    if (_selectedProductId == null) {
      _showSnackBar('Please select a product first', isError: true);
      return;
    }

    final product = _cartItems.firstWhere((item) => item['id'] == _selectedProductId);
    final priceController = TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modify Price'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Price',
            prefixText: 'DA ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text);
              if (newPrice != null && newPrice > 0) {
                _updatePrice(_selectedProductId!, newPrice);
                Navigator.pop(context);
                _showSnackBar('Price updated');
              } else {
                _showSnackBar('Invalid price', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog() {
    if (_selectedProductId == null) {
      _showSnackBar('Please select a product first', isError: true);
      return;
    }

    final product = _cartItems.firstWhere((item) => item['id'] == _selectedProductId);
    final quantityController = TextEditingController(text: product['quantity'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modify Quantity'),
        content: TextField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Quantity',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity = int.tryParse(quantityController.text);
              if (newQuantity != null && newQuantity > 0) {
                _updateQuantity(_selectedProductId!, newQuantity);
                Navigator.pop(context);
                _showSnackBar('Quantity updated');
              } else {
                _showSnackBar('Invalid quantity', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.point_of_sale, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Text('NextGenStock', style: TextStyle(fontSize: 20)),
          ],
        ),
        backgroundColor: _primaryColor,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formattedTime, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              _buildActionButton(
                'Stock',
                icon: Icons.inventory,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StockHomeScreen()),
                ),
                color: _secondaryColor,
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          // Left menu with favorite products (wider now)
          Container(
            width: 150, // Increased width
            decoration: BoxDecoration(
              color: _backgroundColor,
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = _favoriteProducts[index];
                return Tooltip(
                  message: '${product['name']} - ${product['price']} DA',
                  child: InkWell(
                    onTap: () => _addToCart(product),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
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
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${product['price']} DA',
                            style: const TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
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
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _primaryColor.withOpacity(0.3)),
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
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: Row(
                      children: [
                        // Invoice table
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: const EdgeInsets.only(left: 16),
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
                                        (Set<MaterialState> states) => _primaryColor.withOpacity(0.1),
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

                        // Action buttons on the right
                        Container(
                          width: 200,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildActionButton(
                                'Modify Price',
                                icon: Icons.edit,
                                onPressed: _showPriceDialog,
                                color: _accentColor,
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Modify Qty',
                                icon: Icons.numbers,
                                onPressed: _showQuantityDialog,
                                color: _accentColor,
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Ticket',
                                icon: Icons.receipt,
                                onPressed: () => _showSnackBar('Ticket function'),
                                color: _secondaryColor,
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Print',
                                icon: Icons.print,
                                onPressed: () => _showSnackBar('Print function'),
                                color: _secondaryColor,
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Search',
                                icon: Icons.search,
                                onPressed: () => _searchController.text.isNotEmpty 
                                    ? _handleBarcodeScan() 
                                    : _showSnackBar('Enter search term'),
                                color: _primaryColor,
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Return',
                                icon: Icons.keyboard_return,
                                onPressed: () => _showSnackBar('Return function'),
                                color: _primaryColor,
                              ),
                              const Spacer(),
                              const Divider(),
                              _buildActionButton(
                                'Delete',
                                color: _errorColor,
                                icon: Icons.delete,
                                onPressed: () {
                                  if (_selectedProductId != null) {
                                    _removeFromCart(_selectedProductId!);
                                  } else {
                                    _showSnackBar('Select a product first', isError: true);
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Cancel',
                                color: Colors.orange[700],
                                icon: Icons.cancel,
                                onPressed: () {
                                  setState(() {
                                    _cartItems.clear();
                                    _selectedProductId = null;
                                  });
                                  _showSnackBar('Cart cleared');
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                'Promo',
                                color: _secondaryColor,
                                icon: Icons.local_offer,
                                onPressed: () => _showSnackBar('Promo function'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
                        ),
                        Text(
                          formattedTime,
                          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
