import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  final Function(String) onSave;
  final VoidCallback onCancel;

  const AddProductScreen({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subFamilyController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _profitController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _factoryController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _productionExpiryDate;
  DateTime? _expirationDate;
  bool _hasExpirationDate = false; // New state for optional expiration

  // Contemporary color palette
  final Color _primaryColor = const Color(0xFF6C63FF); // Vibrant purple
  final Color _secondaryColor = const Color(0xFF4D8DEE); // Soft blue
  final Color _accentColor = const Color(0xFF00BFA6); // Teal
  final Color _backgroundColor = const Color(0xFFF8F9FA); // Light gray
  final Color _surfaceColor = Colors.white;
  final Color _errorColor = const Color(0xFFFF5252); // Red
  final Color _textColor = const Color(0xFF212529); // Dark gray

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _categoryController.dispose();
    _subFamilyController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _profitController.dispose();
    _quantityController.dispose();
    _factoryController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isProductionDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: _surfaceColor,
              onSurface: _textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isProductionDate) {
          _productionExpiryDate = picked;
        } else {
          _expirationDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Product',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: _textColor),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // General Info Section
              Text(
                'General Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // First row of fields
              _buildFieldRow(
                children: [
                  _buildTextField('Product Name*', _nameController, true),
                  _buildTextField('Product ID*', _idController, true),
                ],
              ),
              const SizedBox(height: 16),

              // Second row of fields
              _buildFieldRow(
                children: [
                  _buildTextField('Category*', _categoryController, true),
                  _buildTextField('Sub-Category', _subFamilyController, false),
                ],
              ),
              const SizedBox(height: 24),

              // Pricing Section
              Text(
                'Pricing Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldRow(
                children: [
                  _buildTextField('Purchase Price', _purchasePriceController, false),
                  _buildDateField(
                    label: 'Production Date',
                    date: _productionExpiryDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField('Manufacturer', _factoryController, false),
              const SizedBox(height: 24),

              // Sales Section
              Text(
                'Sales Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldRow(
                children: [
                  _buildTextField('Selling Price', _sellingPriceController, false),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _hasExpirationDate,
                            onChanged: (value) {
                              setState(() {
                                _hasExpirationDate = value ?? false;
                                if (!_hasExpirationDate) {
                                  _expirationDate = null;
                                }
                              });
                            },
                            activeColor: _primaryColor,
                          ),
                          Text(
                            'Has Expiration',
                            style: TextStyle(color: _textColor),
                          ),
                        ],
                      ),
                      if (_hasExpirationDate)
                        _buildDateField(
                          label: 'Expiration Date',
                          date: _expirationDate,
                          onTap: () => _selectDate(context, false),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField('Product Details', _detailsController, false),
              const SizedBox(height: 24),

              // Inventory Section
              Text(
                'Inventory Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldRow(
                children: [
                  _buildTextField('Profit Margin', _profitController, false),
                  _buildTextField('Quantity*', _quantityController, true),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: _textColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSave(_nameController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('SAVE PRODUCT'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldRow({required List<Widget> children}) {
    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 16),
        Expanded(child: children[1]),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: _textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: _surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'Required field';
            }
            return null;
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: _textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(
                  date == null
                      ? 'Select date'
                      : '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(color: _textColor),
                ),
                const Spacer(),
                Icon(Icons.calendar_today, size: 20, color: _primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}