import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final Color primaryBlue = const Color(0xFF3D8BF2);

  GoogleMapController? _mapController;
  LatLng? _pinLocation;
  bool _isSaving = false;

  // 🔹 Address Details
  String _address = "Move pin or use current location";
  String _addressType = "Home";

  final TextEditingController _addressDetails = TextEditingController();
  final TextEditingController _receiverName = TextEditingController(text: "Atharva Sharma");
  final TextEditingController _receiverPhone = TextEditingController(text: "6375090146");

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // 📍 Get user current location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack("Location services are disabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnack("Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnack("Location permissions are permanently denied");
      return;
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _pinLocation = LatLng(position.latitude, position.longitude);
    });
    _updateAddressFromLatLng(_pinLocation!);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_pinLocation!, 16));
  }

  // 🧭 Convert LatLng → readable address
  Future<void> _updateAddressFromLatLng(LatLng pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _address =
              "${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}, ${p.postalCode ?? ''}";
        });
      }
    } catch (e) {
      debugPrint("Reverse geocoding error: $e");
    }
  }

  // 📩 Save Address
  Future<void> _saveAddress() async {
    if (_receiverName.text.trim().isEmpty ||
        _receiverPhone.text.trim().isEmpty ||
        _addressDetails.text.trim().isEmpty ||
        _pinLocation == null) {
      _showSnack("Please fill all required fields and set location.");
      return;
    }

    if (_receiverPhone.text.length != 10) {
      _showSnack("Please enter a valid 10-digit phone number.");
      return;
    }

    final confirm = await _showConfirmDialog();
    if (!confirm) return;

    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('address_label', _addressType);
      await prefs.setString('address_line', _address);
      await prefs.setString('address_details', _addressDetails.text);
      await prefs.setString('receiver_name', _receiverName.text);
      await prefs.setString('receiver_phone', _receiverPhone.text);
      await prefs.setDouble('latitude', _pinLocation!.latitude);
      await prefs.setDouble('longitude', _pinLocation!.longitude);

      await Future.delayed(const Duration(seconds: 1)); // small UX delay
      _showSnack("✅ Address saved successfully!");
      Navigator.pop(context, true);
    } catch (e) {
      _showSnack("Error saving address. Please try again.");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: primaryBlue),
    );
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Confirm Address Save"),
            content: const Text("Do you want to save this address for deliveries?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Save"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Add New Address"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _buildMap(),
            _buildAddressForm(),
          ],
        ),
      ),
    );
  }
    // 🗺️ Google Map Section
  Widget _buildMap() {
    return Container(
      height: 260,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          if (_pinLocation != null)
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _pinLocation!, zoom: 15),
              onMapCreated: (controller) => _mapController = controller,
              markers: {
                Marker(
                  markerId: const MarkerId("pin"),
                  position: _pinLocation!,
                  draggable: true,
                  onDragEnd: (pos) {
                    setState(() => _pinLocation = pos);
                    _updateAddressFromLatLng(pos);
                  },
                ),
              },
              myLocationEnabled: true,
              onTap: (pos) {
                setState(() => _pinLocation = pos);
                _updateAddressFromLatLng(pos);
              },
            )
          else
            const Center(child: CircularProgressIndicator()),

          // 🔍 Search bar placeholder (for future Google Places API)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 6)
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search your location...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // 📍 Use current location button
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton.icon(
              onPressed: _determinePosition,
              icon: const Icon(Icons.my_location_outlined),
              label: const Text("Use current location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧾 Address Input Form Section
  Widget _buildAddressForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Delivery Details",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _readonlyField(
              "Detected Address", _address, Icons.location_on_outlined),
          const SizedBox(height: 10),
          _inputField("Flat / Floor / Building Name", _addressDetails,
              Icons.home_outlined),
          const SizedBox(height: 20),

          const Text("Receiver Details",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _inputField("Receiver Name", _receiverName, Icons.person_outline),
          const SizedBox(height: 10),
          _inputField("Phone Number", _receiverPhone, Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 20),

          const Text("Save address as",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _addressTypeButton("Home", Icons.home_outlined),
              _addressTypeButton("Work", Icons.work_outline),
              _addressTypeButton("Other", Icons.location_on_outlined),
            ],
          ),

          const SizedBox(height: 30),
          _isSaving
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _saveAddress,
                  child: const Text(
                    "Save Address",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
    // 🧱 Reusable Text Field (for input)
  Widget _inputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (val) {
        // 🧠 Optional: Live form validation / saving logic
        if (val.length > 100) {
          _showSnack("Address field too long!");
        }
      },
    );
  }

  // 🔒 Read-Only Field (Detected Address)
  Widget _readonlyField(String label, String value, IconData icon) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      maxLines: 2,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🏠 Address Type Selector (Home / Work / Other)
  Widget _addressTypeButton(String label, IconData icon) {
    final bool isSelected = _addressType == label;
    return OutlinedButton.icon(
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
      ),
      onPressed: () => setState(() => _addressType = label),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? primaryBlue : Colors.white,
        side: BorderSide(
          color: isSelected ? primaryBlue : Colors.grey.shade300,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🧩 Optional (Future): Google Places Autocomplete Integration
  // For production, we can replace the search TextField with an autocomplete search
  // using the Google Places API to fetch suggestions dynamically.
  //
  // Example (pseudo):
  // void _onSearchChanged(String query) async {
  //   final results = await PlacesService.getSuggestions(query);
  //   setState(() => _suggestions = results);
  // }
  //
  // Then show a dropdown of suggestions below the search bar.

  // 🧹 Clean-up resources
  @override
  void dispose() {
    _mapController?.dispose();
    _addressDetails.dispose();
    _receiverName.dispose();
    _receiverPhone.dispose();
    super.dispose();
  }
}