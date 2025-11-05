import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellerInventoryScreen extends StatefulWidget {
  const SellerInventoryScreen({super.key});

  @override
  State<SellerInventoryScreen> createState() => _SellerInventoryScreenState();
}

class _SellerInventoryScreenState extends State<SellerInventoryScreen> {
  final ImagePicker _picker = ImagePicker();

  // 🧺 Temporary sample inventory
  final List<Map<String, dynamic>> _inventory = [
    {
      'name': 'Amul Milk 500ml',
      'category': 'Dairy',
      'lowStock': 5,
      'quantity': 24,
      'mrp': '35',
      'price': '30',
      'discount': 10.0,
      'label': '500ml',
      'unit': 'ml',
      'image': null,
    },
    {
      'name': 'Brown Bread 400g',
      'category': 'Bakery',
      'lowStock': 5,
      'quantity': 10,
      'mrp': '45',
      'price': '40',
      'discount': 0.0,
      'label': '400g',
      'unit': 'g',
      'image': null,
    },
  ];

  String _selectedFilter = 'Default';

  void _deleteItem(int index) => setState(() => _inventory.removeAt(index));

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3D8BF2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _applyFilter() {
    setState(() {
      switch (_selectedFilter) {
        case 'Highest Discount':
          _inventory.sort((a, b) => (b['discount'] ?? 0).compareTo(a['discount'] ?? 0));
          break;
        case 'Low Stock':
          _inventory.sort((a, b) => (a['quantity'] ?? 0).compareTo(b['quantity'] ?? 0));
          break;
        case 'Alphabetical':
          _inventory.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
          break;
        default:
          break;
      }
    });
  }

  Future<void> _showAddOrEditProductDialog({Map<String, dynamic>? existingItem, int? index}) async {
    final nameCtrl = TextEditingController(text: existingItem?['name'] ?? '');
    final categoryCtrl = TextEditingController(text: existingItem?['category'] ?? '');
    final descCtrl = TextEditingController(text: existingItem?['description'] ?? '');
    final skuCtrl = TextEditingController(text: existingItem?['sku'] ?? '');
    final barcodeCtrl = TextEditingController(text: existingItem?['barcode'] ?? '');
    final lowStockCtrl = TextEditingController(text: existingItem?['lowStock']?.toString() ?? '');
    final quantityCtrl = TextEditingController(text: existingItem?['quantity']?.toString() ?? '');
    final mrpCtrl = TextEditingController(text: existingItem?['mrp'] ?? '');
    final sellingPriceCtrl = TextEditingController(text: existingItem?['price'] ?? '');
    final discountCtrl = TextEditingController(text: existingItem?['discount']?.toString() ?? '');
    final taxCtrl = TextEditingController(text: existingItem?['taxPercent'] ?? '');
    final quantityLabelCtrl = TextEditingController(text: existingItem?['label'] ?? '');

    final units = ['gm', 'kg', 'ml', 'L', 'pcs'];
    String? selectedUnit = existingItem?['unit'];

    XFile? pickedImage;
    File? existingImageFile;
    if (existingItem != null && existingItem['image'] != null) {
      if (existingItem['image'] is File) {
        existingImageFile = existingItem['image'];
      } else if (existingItem['image'] is String) {
        existingImageFile = File(existingItem['image']);
      }
    }

    bool trackStock = existingItem?['trackStock'] ?? true;
    bool isActive = existingItem?['isActive'] ?? true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> _pickImageAndSet(ImageSource source) async {
              final img = await _picker.pickImage(source: source, imageQuality: 80);
              if (img != null) {
                setStateModal(() {
                  pickedImage = img;
                  existingImageFile = null;
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existingItem == null ? 'Add New Product' : 'Edit Product',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(modalContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Image Picker
                    GestureDetector(
                      onTap: () async {
                        final source = await showModalBottomSheet<ImageSource>(
                          context: context,
                          builder: (ctx2) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Camera'),
                                  onTap: () => Navigator.pop(ctx2, ImageSource.camera),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () => Navigator.pop(ctx2, ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (source != null) await _pickImageAndSet(source);
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF5FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF3D8BF2)),
                        ),
                        child: pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(File(pickedImage!.path), fit: BoxFit.cover),
                              )
                            : existingImageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(existingImageFile!, fit: BoxFit.cover),
                                  )
                                : const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo, size: 40, color: Color(0xFF3D8BF2)),
                                        SizedBox(height: 8),
                                        Text('Tap to upload image'),
                                      ],
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form Fields
                    _buildTextField('Product Name *', nameCtrl, Icons.label_outline),
                    const SizedBox(height: 12),
                    _buildTextField('Category *', categoryCtrl, Icons.category_outlined),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Short Description',
                        prefixIcon: const Icon(Icons.note_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // SKU & Barcode
                    Row(
                      children: [
                        Expanded(child: _buildTextField('SKU', skuCtrl, Icons.confirmation_number_outlined)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('Barcode', barcodeCtrl, Icons.qr_code_2)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Stock
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('Track Stock'),
                            value: trackStock,
                            activeColor: const Color(0xFF3D8BF2),
                            onChanged: (v) => setStateModal(() => trackStock = v),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: _buildTextField('Low Stock', lowStockCtrl, Icons.warning_amber_rounded,
                              type: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Quantity & Unit
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Quantity Available', quantityCtrl,
                              Icons.inventory_2_outlined, type: TextInputType.number),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: (selectedUnit != null &&
                                    ['gm', 'kg', 'ml', 'L', 'pcs'].contains(selectedUnit))
                                ? selectedUnit
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: ['gm', 'kg', 'ml', 'L', 'pcs']
                                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                .toList(),
                            onChanged: (v) => setStateModal(() => selectedUnit = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Prices & Discount
                    Row(
                      children: [
                        Expanded(child: _buildTextField('MRP (₹)', mrpCtrl, Icons.price_change, type: TextInputType.number)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('Selling Price (₹)', sellingPriceCtrl, Icons.sell_outlined, type: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Discount %', discountCtrl, Icons.local_offer_outlined, type: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField('Tax %', taxCtrl, Icons.percent, type: TextInputType.number),
                    const SizedBox(height: 12),

                    SwitchListTile(
                      title: const Text('Active (visible on store)'),
                      value: isActive,
                      activeColor: const Color(0xFF3D8BF2),
                      onChanged: (v) => setStateModal(() => isActive = v),
                    ),
                    const SizedBox(height: 18),

                    // Save Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D8BF2),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty || categoryCtrl.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: const Text("Missing Information"),
                              content: const Text("Please fill all required fields (Name and Category)."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text("OK", style: TextStyle(color: Color(0xFF3D8BF2))),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        final newProduct = {
                          'name': nameCtrl.text.trim(),
                          'category': categoryCtrl.text.trim(),
                          'description': descCtrl.text.trim(),
                          'sku': skuCtrl.text.trim(),
                          'barcode': barcodeCtrl.text.trim(),
                          'lowStock': int.tryParse(lowStockCtrl.text.trim()) ?? 0,
                          'quantity': int.tryParse(quantityCtrl.text.trim()) ?? 0,
                          'mrp': mrpCtrl.text.trim(),
                          'price': sellingPriceCtrl.text.trim(),
                          'discount': double.tryParse(discountCtrl.text.trim()) ?? 0.0,
                          'taxPercent': taxCtrl.text.trim(),
                          'label': quantityLabelCtrl.text.trim(),
                          'unit': selectedUnit ?? '',
                          'trackStock': trackStock,
                          'isActive': isActive,
                          'image': pickedImage != null ? File(pickedImage!.path) : existingImageFile,
                        };

                        setState(() {
                          if (existingItem != null && index != null) {
                            _inventory[index] = newProduct;
                          } else {
                            _inventory.insert(0, newProduct);
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Text(existingItem == null ? 'Add Product' : 'Save Changes',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🧱 MAIN PAGE UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: const Color(0xFF3D8BF2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔽 Filter Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sort by:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: ['Default', 'Highest Discount', 'Low Stock', 'Alphabetical']
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilter = value;
                        _applyFilter();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🧱 Product Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: _inventory.length,
                itemBuilder: (context, index) {
                  final item = _inventory[index];
                  final stock = item['quantity'];
                  final lowStock = item['lowStock'];

                  return Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: item['image'] != null
                                      ? Image.file(item['image'], width: double.infinity, fit: BoxFit.cover)
                                      : Image.asset('assets/images/placeholder.png',
                                          width: double.infinity, fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(item['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  overflow: TextOverflow.ellipsis),
                              Text("Category: ${item['category']}",
                                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("₹${item['price']}",
                                      style: const TextStyle(
                                          color: Color(0xFF3D8BF2),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                  Text("₹${item['mrp']}",
                                      style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 13)),
                                ],
                              ),
                              Text("Pack: ${item['label']} ${item['unit']}",
                                  style: const TextStyle(fontSize: 12, color: Colors.black87)),
                              Text(
                                "Stock: $stock",
                                style: TextStyle(
                                  color: stock <= lowStock ? Colors.redAccent : Colors.black87,
                                  fontWeight: stock <= lowStock ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF3D8BF2)),
                                    onPressed: () =>
                                        _showAddOrEditProductDialog(existingItem: item, index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _deleteItem(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 🏷️ Discount Tag
                      if (item['discount'] != null && item['discount'] > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "-${item['discount']}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                    fontWeight: FontWeight.bold,
  ),
),
),
),
],
);
},
),
),
],
),
),
floatingActionButton: FloatingActionButton(
backgroundColor: const Color(0xFF3D8BF2),
onPressed: () => _showAddOrEditProductDialog(),
child: const Icon(Icons.add),
),
);
}
}