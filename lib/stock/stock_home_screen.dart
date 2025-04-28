import 'package:flutter/material.dart';
import 'package:next/stock/add_product_screen.dart';
import 'package:next/stock/edit_product_screen.dart';
import 'package:next/stock/category_screen.dart';
import 'package:next/stock/profit_and_loss.dart';

class StockHomeScreen extends StatefulWidget {
  const StockHomeScreen({super.key});

  @override
  State<StockHomeScreen> createState() => _StockHomeScreenState();
}

class _StockHomeScreenState extends State<StockHomeScreen> {
  bool _showProductSetting = false;
  bool _showAddProduct = false;
  final List<String> _products = [];
  String? _selectedMenuOption;
  final TextEditingController _searchController = TextEditingController();
  bool _showEditDeleteFrame = false;
  String? _actionType; // 'edit' or 'delete'
  final TextEditingController _frameSearchController = TextEditingController();

  // Modern color palette
  static const Color _primaryColor = Color(0xFF6C63FF); // Vibrant purple
  static const Color _secondaryColor = Color(0xFF4D8DEE); // Soft blue
  static const Color _surfaceColor = Colors.white;
  static const Color _backgroundLight = Color(0xFFF8F9FA);
  static const Color _textColor = Color(0xFF2D3748); // Dark gray
  static const Color _errorColor = Color(0xFFFF5252); // Red

  List<String> get _filteredProducts {
    final query = _searchController.text.toLowerCase();
    return _products.where((product) => product.toLowerCase().contains(query)).toList();
  }

  List<String> get _frameFilteredProducts {
    final query = _frameSearchController.text.toLowerCase();
    return _products.where((product) => product.toLowerCase().contains(query)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _frameSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NextGenStock', style: TextStyle(color: _textColor)),
        centerTitle: true,
        backgroundColor: _surfaceColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: _textColor),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Menu
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _backgroundLight,
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuOption('Product Setting', Icons.settings, 'product_setting'),
                _buildMenuOption('Categories', Icons.category, 'categories'),
                _buildMenuOption('Stock Levels', Icons.assessment, 'stock_levels'),
                _buildMenuOption('Track Product', Icons.track_changes, 'track_product'),
                _buildMenuOption('Record Stock', Icons.inventory, 'record_stock'),
                _buildMenuOption('Profit and Loss', Icons.attach_money, 'profit_loss'),
                _buildMenuOption('Log Damage', Icons.warning, 'log_damage'),
                _buildMenuOption('Alerts', Icons.notifications, 'alerts'),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Products List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSearchBar(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey[200]!),
                            ),
                            child: ListTile(
                              title: Text(_filteredProducts[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: _errorColor),
                                onPressed: () {
                                  setState(() {
                                    _products.remove(_filteredProducts[index]);
                                  });
                                },
                              ),
                              onTap: () => _showEditDialog(context, _filteredProducts[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Product Setting Popup
                if (_selectedMenuOption == 'product_setting' && !_showEditDeleteFrame)
                  Center(
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'PRODUCT SETTING',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    Icons.add,
                                    'Add',
                                    _primaryColor,
                                        () => setState(() => _showAddProduct = true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    Icons.edit,
                                    'Edit',
                                    _secondaryColor,
                                        () {
                                      if (_products.isNotEmpty) {
                                        setState(() {
                                          _showEditDeleteFrame = true;
                                          _actionType = 'edit';
                                        });
                                      } else {
                                        _showNoProductWarning();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildActionButton(
                                    Icons.delete,
                                    'Delete',
                                    _errorColor,
                                        () {
                                      if (_products.isNotEmpty) {
                                        setState(() {
                                          _showEditDeleteFrame = true;
                                          _actionType = 'delete';
                                        });
                                      } else {
                                        _showNoProductWarning();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedMenuOption = null;
                                });
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Edit/Delete Frame
                if (_showEditDeleteFrame)
                  Center(
                    child: Material(
                      elevation: 16,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _actionType == 'edit' ? 'EDIT PRODUCT' : 'DELETE PRODUCT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _actionType == 'edit' ? _secondaryColor : _errorColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _frameSearchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _backgroundLight,
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search products...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _frameFilteredProducts.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.grey[200]!),
                                    ),
                                    child: ListTile(
                                      title: Text(_frameFilteredProducts[index]),
                                      trailing: _actionType == 'edit'
                                          ? IconButton(
                                        icon: Icon(Icons.edit, color: _secondaryColor),
                                        onPressed: () {
                                          _showEditDialog(context, _frameFilteredProducts[index]);
                                          setState(() {
                                            _showEditDeleteFrame = false;
                                            _actionType = null;
                                          });
                                        },
                                      )
                                          : IconButton(
                                        icon: Icon(Icons.delete, color: _errorColor),
                                        onPressed: () {
                                          _showDeleteConfirmation(context, _frameFilteredProducts[index]);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showEditDeleteFrame = false;
                                      _actionType = null;
                                      _frameSearchController.clear();
                                    });
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Add Product Screen Overlay
                if (_showAddProduct)
                  Stack(
                    children: [
                      ModalBarrier(
                        color: Colors.black54,
                        dismissible: true,
                        onDismiss: () => setState(() => _showAddProduct = false),
                      ),
                      Center(
                        child: Material(
                          elevation: 16,
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: AddProductScreen(
                              onSave: (productName) {
                                if (productName.isNotEmpty) {
                                  setState(() {
                                    _products.add(productName);
                                    _showAddProduct = false;
                                  });
                                }
                              },
                              onCancel: () => setState(() => _showAddProduct = false),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _errorColor),
            onPressed: () {
              setState(() {
                _products.remove(productName);
                Navigator.pop(context);
                setState(() {
                  _showEditDeleteFrame = false;
                  _actionType = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"$productName" deleted'),
                    backgroundColor: _errorColor,
                  ),
                );
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: _backgroundLight,
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search products...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        suffixIcon: IconButton(
          icon: const Icon(Icons.barcode_reader),
          onPressed: () => _showBarcodeDialog(context),
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  void _showBarcodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Barcode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Place barcode in front of camera'),
            const SizedBox(height: 20),
            Container(
              height: 200,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Icon(Icons.barcode_reader, size: 100, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulate barcode scan
              setState(() {
                _searchController.text = 'PROD-12345';
                Navigator.pop(context);
              });
            },
            child: const Text('Simulate Scan'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String productName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          productName: productName,
          productIds: [], // Empty list for IDs (you can add your own if needed)
          quantity: 0,    // Default quantity (you can add your own if needed)
          salePrice: 0.0, // Default sale price (you can add your own if needed)
          costPrice: 0.0, // Default cost price (you can add your own if needed)
          onSave: (newName, ids, quantity, salePrice, costPrice) {
            setState(() {
              final index = _products.indexOf(productName);
              if (index != -1) {
                _products[index] = newName;
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"$productName" updated to "$newName"'),
                backgroundColor: _secondaryColor,
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }



// Update the _buildMenuOption method
  Widget _buildMenuOption(String title, IconData icon, String value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _selectedMenuOption == value ? _primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: _selectedMenuOption == value
            ? Border.all(color: _primaryColor)
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, size: 20, color: _selectedMenuOption == value ? _primaryColor : _textColor),
        title: Text(title, style: TextStyle(
          fontWeight: _selectedMenuOption == value ? FontWeight.bold : FontWeight.normal,
          color: _selectedMenuOption == value ? _primaryColor : _textColor,
        )),
        onTap: () {
          if (value == 'categories') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
            return;
          }


          setState(() {
            _selectedMenuOption = _selectedMenuOption == value ? null : value;
            _showEditDeleteFrame = false;
            _actionType = null;
          });
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: _surfaceColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  void _showNoProductWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('No products available'),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}