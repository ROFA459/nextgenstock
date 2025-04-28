import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class EditProductScreen extends StatefulWidget {
  final String productName;
  final List<String> productIds;
  final int quantity;
  final double salePrice;
  final double costPrice;
  final Function(String, List<String>, int, double, double) onSave;
  final VoidCallback onCancel;

  const EditProductScreen({
    super.key,
    required this.productName,
    required this.productIds,
    required this.quantity,
    required this.salePrice,
    required this.costPrice,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  late final TextEditingController _quantityController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _costPriceController;
  late List<String> _productIds;
  final _formKey = GlobalKey<FormState>();

  // Color palette matching NextGenStock
  static const Color _primaryColor = Color(0xFF6C63FF);
  static const Color _secondaryColor = Color(0xFF4D8DEE);
  static const Color _surfaceColor = Colors.white;
  static const Color _backgroundLight = Color(0xFFF8F9FA);
  static const Color _textColor = Color(0xFF2D3748);
  static const Color _errorColor = Color(0xFFFF5252);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _profitColor = Color(0xFF4CAF50);
  static const Color _lossColor = Color(0xFFF44336);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName);
    _idController = TextEditingController();
    _quantityController = TextEditingController(text: widget.quantity.toString());
    _salePriceController = TextEditingController(text: widget.salePrice.toStringAsFixed(2));
    _costPriceController = TextEditingController(text: widget.costPrice.toStringAsFixed(2));
    _productIds = List.from(widget.productIds);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _quantityController.dispose();
    _salePriceController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    try {
      FocusScope.of(context).unfocus();
      final String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#6C63FF',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;
      if (barcode != '-1') {
        setState(() {
          _idController.text = barcode;
          _addProductId();
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar('Scanning error: ${e.toString()}');
    }
  }

  void _addProductId() {
    final id = _idController.text.trim();
    if (id.isNotEmpty) {
      if (_productIds.contains(id)) {
        _showErrorSnackbar('ID already exists');
      } else {
        setState(() {
          _productIds.add(id);
          _idController.clear();
        });
      }
    }
  }

  void _removeProductId(String id) {
    setState(() => _productIds.remove(id));
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_productIds.isEmpty) {
        _showErrorSnackbar('Add at least one product ID');
        return;
      }

      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final salePrice = double.tryParse(_salePriceController.text) ?? 0;
      final costPrice = double.tryParse(_costPriceController.text) ?? 0;

      if (quantity < 0) {
        _showErrorSnackbar('Quantity cannot be negative');
        return;
      }

      if (costPrice > salePrice) {
        _showErrorSnackbar('Sale price should be higher than cost');
        return;
      }

      widget.onSave(
        _nameController.text.trim(),
        _productIds,
        quantity,
        salePrice,
        costPrice,
      );
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPriceField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        prefixText: '\$ ',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (double.tryParse(value) == null) return 'Invalid amount';
        return null;
      },
    );
  }

  Widget _buildProfitIndicator() {
    final salePrice = double.tryParse(_salePriceController.text) ?? 0;
    final costPrice = double.tryParse(_costPriceController.text) ?? 0;
    final profit = salePrice - costPrice;
    final profitMargin = costPrice > 0 ? (profit / costPrice) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            profit >= 0 ? Icons.trending_up : Icons.trending_down,
            color: profit >= 0 ? _profitColor : _lossColor,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profit: \$${profit.toStringAsFixed(2)}',
                style: TextStyle(
                  color: profit >= 0 ? _profitColor : _lossColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Margin: ${profitMargin.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: profit >= 0 ? _profitColor : _lossColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: _surfaceColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: _textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProduct,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                  filled: true,
                  fillColor: _backgroundLight,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                  filled: true,
                  fillColor: _backgroundLight,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter quantity';
                  if (int.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Section
              const Text(
                'Pricing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceField(_costPriceController, 'Cost Price', Icons.money_off),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPriceField(_salePriceController, 'Sale Price', Icons.attach_money),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildProfitIndicator(),
              const SizedBox(height: 16),

              // Product IDs Section
              const Text(
                'Product IDs/Barcodes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_productIds.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'No IDs added yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _productIds.map((id) => Chip(
                    label: Text(id),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeProductId(id),
                    backgroundColor: _primaryColor.withOpacity(0.1),
                  )).toList(),
                ),
              const SizedBox(height: 16),

              // Add ID Section
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: 'Add Product ID',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: _backgroundLight,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.barcode_reader),
                          onPressed: _scanBarcode,
                        ),
                      ),
                      onFieldSubmitted: (_) => _addProductId(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addProductId,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _primaryColor),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: _primaryColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}