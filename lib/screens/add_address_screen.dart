import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final Color primaryBlue = const Color(0xFF3D8BF2);

  GoogleMapController? _mapController;
  LatLng? _pinLocation;
  String _address = "Move pin or use current location";
  String _addressType = "Home";

  final TextEditingController _addressDetails = TextEditingController();
  final TextEditingController _receiverName =
      TextEditingController(text: "Atharva Sharma");
  final TextEditingController _receiverPhone =
      TextEditingController(text: "6375090146");

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    final position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _pinLocation = LatLng(position.latitude, position.longitude);
    });
    _updateAddressFromLatLng(_pinLocation!);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_pinLocation!, 16),
    );
  }

  // 🧭 Convert LatLng to readable address
  Future<void> _updateAddressFromLatLng(LatLng pos) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
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
        child: Column(
          children: [
            // 🗺️ Map
            Container(
              height: 260,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
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

                  // 🔍 Search bar placeholder
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

                  // 📍 Use current location
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
            ),

            // 🏠 Address Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Delivery Details",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _readonlyField("Detected Address", _address,
                        Icons.location_on_outlined),
                    const SizedBox(height: 10),
                    _inputField("Flat / Floor / Building Name", _addressDetails,
                        Icons.home_outlined),
                    const SizedBox(height: 20),

                    const Text("Receiver Details",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _inputField("Receiver Name", _receiverName,
                        Icons.person_outline),
                    const SizedBox(height: 10),
                    _inputField("Phone Number", _receiverPhone,
                        Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 20),

                    const Text("Save address as",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _saveAddress,
                      child: const Text("Save Address",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 30),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  // 🧱 Widgets
  Widget _inputField(String label, TextEditingController controller,
      IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _readonlyField(String label, String value, IconData icon) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _addressTypeButton(String label, IconData icon) {
    final bool isSelected = _addressType == label;
    return OutlinedButton.icon(
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
      label: Text(label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
      onPressed: () => setState(() => _addressType = label),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? primaryBlue : Colors.white,
        side:
            BorderSide(color: isSelected ? primaryBlue : Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _saveAddress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address saved successfully!")),
    );
    Navigator.pop(context);
  }
}