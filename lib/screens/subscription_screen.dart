import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<Map<String, dynamic>> subscriptions = [
    {
      "item": "Amul Milk (500ml)",
      "frequency": "Daily",
      "quantity": 1,
      "price": 30,
      "active": true,
    },
    {
      "item": "Eggs (6 pcs)",
      "frequency": "Alternate Days",
      "quantity": 1,
      "price": 60,
      "active": true,
    },
    {
      "item": "Brown Bread",
      "frequency": "Weekly",
      "quantity": 1,
      "price": 45,
      "active": false,
    },
  ];

  // Track the overall pause switch state
  bool pauseAll = false; 


    // 🔹 Load subscriptions from local storage
  Future<void> _loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('subscriptions');
    if (savedData != null) {
      final List decoded = jsonDecode(savedData);
      setState(() {
        subscriptions = decoded.cast<Map<String, dynamic>>();
        pauseAll = subscriptions.isNotEmpty && subscriptions.every((s) => !s["active"]);
      });
    }
  }

  // 🔹 Save subscriptions to local storage
  Future<void> _saveSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscriptions', jsonEncode(subscriptions));
  }
    @override
  void initState() {
    super.initState();
    _loadSubscriptions(); // 🧠 Load saved data when screen starts
  }

  void _toggleActive(int index) {
    setState(() {
      subscriptions[index]["active"] = !subscriptions[index]["active"];
      // Update pauseAll switch if any subscription is active
      pauseAll = subscriptions.every((s) => !s["active"]);
    });
    _saveSubscriptions();
  }

  void _toggleAllSubscriptions(bool value) {
    setState(() {
      pauseAll = value;
      for (var sub in subscriptions) {
        sub["active"] = !pauseAll;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pauseAll
              ? "All subscriptions paused ⏸️"
              : "All subscriptions resumed ▶️",
        ),
        backgroundColor: const Color(0xFF3D8BF2),
        duration: const Duration(seconds: 2),
      ),
    );
    _saveSubscriptions();
  }

   void _editSubscription(int index) {
    _openSubscriptionEditor(
      isEdit: true,
      index: index,
      existingSub: subscriptions[index],
    );
    _saveSubscriptions();
  }

  void _addNewSubscription() {
    _openSubscriptionEditor(isEdit: false);
    _saveSubscriptions();
  }

  void _openSubscriptionEditor({
    required bool isEdit,
    int? index,
    Map<String, dynamic>? existingSub,
  }) {
    String item = existingSub?["item"] ?? "";
    String freq = existingSub?["frequency"] ?? "Daily";
    int qty = existingSub?["quantity"] ?? 1;
    int price = existingSub?["price"] ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Use StatefulBuilder to manage temporary form state inside sheet
        return StatefulBuilder(builder: (context, setModalState) {
          // Create controllers that reflect current values, but do not persist controllers across rebuilds
          final TextEditingController itemController =
              TextEditingController(text: item);
          final TextEditingController priceController =
              TextEditingController(text: price == 0 ? "" : price.toString());

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? "Edit Subscription" : "Add New Subscription",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    labelText: "Item Name",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => item = val,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: freq,
                  items: ["Daily", "Alternate Days", "Weekly"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setModalState(() => freq = val!);
                  },
                  decoration: const InputDecoration(labelText: "Frequency"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Quantity", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (qty > 1) setModalState(() => qty--);
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text("$qty",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setModalState(() => qty++),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: "Price (₹)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) =>
                      price = int.tryParse(val) ?? existingSub?["price"] ?? 0,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D8BF2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Use the controller values in case user didn't trigger onChanged
                    item = itemController.text.trim();
                    price = int.tryParse(priceController.text) ?? price;

                    if (item.isEmpty || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Please enter a valid item name and price"),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (isEdit && index != null) {
                        subscriptions[index] = {
                          "item": item,
                          "frequency": freq,
                          "quantity": qty,
                          "price": price,
                          "active": true,
                        };
                      } else {
                        subscriptions.add({
                          "item": item,
                          "frequency": freq,
                          "quantity": qty,
                          "price": price,
                          "active": true,
                        });
                      }
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEdit
                              ? "Subscription updated"
                              : "Subscription added successfully",
                        ),
                        backgroundColor: const Color(0xFF3D8BF2),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    isEdit ? "Save Changes" : "Add Subscription",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        title: const Text(
          "My Subscriptions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🟦 Pause All Subscriptions
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pause All Subscriptions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    activeColor: const Color(0xFF3D8BF2),
                    value: pauseAll,
                    onChanged: _toggleAllSubscriptions,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Subscription Cards
            Expanded(
              child: ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final sub = subscriptions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub["item"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Frequency: ${sub["frequency"]}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "Quantity: ${sub["quantity"]} | ₹${sub["price"]}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: sub["active"]
                                      ? Colors.redAccent
                                      : const Color(0xFF3D8BF2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => _toggleActive(index),
                                child: Text(
                                  sub["active"] ? "Pause" : "Resume",
                                  style:
                                      const TextStyle(color: Colors.white),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => _editSubscription(index),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF3D8BF2)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Edit",
                                  style:
                                      TextStyle(color: Color(0xFF3D8BF2)),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    subscriptions.removeAt(index);
                                    pauseAll = subscriptions.isNotEmpty &&
                                        subscriptions.every(
                                            (s) => !s["active"]);
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.redAccent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ➕ Floating Action Button
     floatingActionButton: FloatingActionButton.extended(
  backgroundColor: const Color(0xFF3D8BF2),
  onPressed: _addNewSubscription,
  icon: const Icon(Icons.add, color: Colors.white),
  label: const Text(
    "Add New",
    style: TextStyle(color: Colors.white),
  ),
),
    );
  }
}