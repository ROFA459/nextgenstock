import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final List<String>? subcategories;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.subcategories,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Category copyWith({
    String? name,
    List<String>? subcategories,
    String? description,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      subcategories: subcategories ?? this.subcategories,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Category> _categories = [
    Category(id: '1', name: 'Red Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '2', name: 'White Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '3', name: 'Fish and Seafood', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '4', name: 'Fresh Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '5', name: 'Dried Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '6', name: 'Smoked Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '7', name: 'Ground Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '8', name: 'Processed Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '9', name: 'Lean Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Category(id: '10', name: 'Medium-Fat Meat', createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  Category? _currentCategory;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subcategoriesController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _subcategoriesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameController.clear();
    _subcategoriesController.clear();
    _descriptionController.clear();
    _currentCategory = null;
    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _resetForm();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit Category' : 'Create New Category',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _subcategoriesController,
                        decoration: const InputDecoration(
                          labelText: 'Subcategories (comma separated)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.list),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isEditing)
                            TextButton(
                              onPressed: _resetForm,
                              child: const Text('Cancel'),
                            ),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text(_isEditing ? 'Update' : 'Create'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // List Section
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.category, color: Colors.blue),
                      title: Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: category.subcategories?.isNotEmpty ?? false
                          ? Text('Subcategories: ${category.subcategories!.join(', ')}')
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editCategory(category),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category.id),
                          ),
                        ],
                      ),
                      onTap: () => _showCategoryDetails(category),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newCategory = Category(
        id: _isEditing ? _currentCategory!.id : DateTime.now().toString(),
        name: _nameController.text,
        subcategories: _subcategoriesController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        createdAt: _isEditing ? _currentCategory!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      setState(() {
        if (_isEditing) {
          final index = _categories.indexWhere((cat) => cat.id == _currentCategory!.id);
          _categories[index] = newCategory;
        } else {
          _categories.add(newCategory);
        }
        _resetForm();
      });
    }
  }

  void _editCategory(Category category) {
    setState(() {
      _currentCategory = category;
      _isEditing = true;
      _nameController.text = category.name;
      _subcategoriesController.text = category.subcategories?.join(', ') ?? '';
      _descriptionController.text = category.description ?? '';
    });
  }

  void _deleteCategory(String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.removeWhere((cat) => cat.id == categoryId);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCategoryDetails(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (category.subcategories?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Subcategories: ${category.subcategories!.join(', ')}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (category.description != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(category.description!),
                ),
              const Divider(),
              Text(
                'Created: ${_formatDate(category.createdAt)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Last updated: ${_formatDate(category.updatedAt)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}