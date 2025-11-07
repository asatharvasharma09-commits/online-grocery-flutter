import 'package:flutter/material.dart';
import 'seller_registration_success_screen.dart';

class SellerRegistrationWizard extends StatefulWidget {
  const SellerRegistrationWizard({super.key});

  @override
  State<SellerRegistrationWizard> createState() => _SellerRegistrationWizardState();
}

class _SellerRegistrationWizardState extends State<SellerRegistrationWizard> {
  final PageController _pageController = PageController();
  final Color primaryBlue = const Color(0xFF3D8BF2);
  int _currentStep = 0;

  // Form keys for validation per step
  final _personalFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();
  final _bankFormKey = GlobalKey<FormState>();
  final _kycFormKey = GlobalKey<FormState>();
  final _warehouseFormKey = GlobalKey<FormState>();

  // Controllers
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final categoryC = TextEditingController();

  final businessNameC = TextEditingController();
  final gstinC = TextEditingController();
  final businessTypeC = TextEditingController();
  final panC = TextEditingController();
  final industryC = TextEditingController();

  final accHolderC = TextEditingController();
  final bankNameC = TextEditingController();
  final accNumC = TextEditingController();
  final ifscC = TextEditingController();
  final upiC = TextEditingController();

  final aadhaarC = TextEditingController();
  final panVerifyC = TextEditingController();
  final kycStatusC = TextEditingController(text: "Pending");

  final pickupAddressC = TextEditingController();
  final warehouseAddressC = TextEditingController();
  final cityC = TextEditingController();
  final pincodeC = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 🔹 Validation check for current step
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _personalFormKey.currentState?.validate() ?? false;
      case 1:
        return _businessFormKey.currentState?.validate() ?? false;
      case 2:
        return _bankFormKey.currentState?.validate() ?? false;
      case 3:
        return _kycFormKey.currentState?.validate() ?? false;
      case 4:
        return _warehouseFormKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 4) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SellerRegistrationSuccessScreen()),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Seller Registration"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _progressBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfo(),
                _buildBusinessDetails(),
                _buildBankDetails(),
                _buildKycDetails(),
                _buildWarehouseDetails(),
              ],
            ),
          ),
          _navigationButtons(),
        ],
      ),
    );
  }

  // 🧭 Progress Bar
  Widget _progressBar() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: LinearProgressIndicator(
          value: (_currentStep + 1) / 5,
          backgroundColor: Colors.grey[300],
          color: primaryBlue,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
      );

  // 🔘 Navigation Buttons
  Widget _navigationButtons() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Back"),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentStep == 4 ? "Submit & Register" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  // 🧩 STEP 1 — Personal Info
  Widget _buildPersonalInfo() => _formSection(
        key: _personalFormKey,
        title: "Personal Information",
        fields: [
          _validatedField("Seller Name", nameC, required: true),
          _validatedField("Email", emailC, email: true),
          _validatedField("Phone", phoneC, phone: true),
          _validatedField("Address", addressC, required: true),
          _validatedField("Category", categoryC, required: true),
        ],
      );

  // 🧩 STEP 2 — Business Details
  Widget _buildBusinessDetails() => _formSection(
        key: _businessFormKey,
        title: "Business Details",
        fields: [
          _validatedField("Business Name", businessNameC, required: true),
          _validatedField("GSTIN", gstinC, gstin: true),
          _validatedField("Business Type", businessTypeC, required: true),
          _validatedField("PAN", panC, pan: true),
          _validatedField("Industry", industryC, required: true),
        ],
      );

  // 🧩 STEP 3 — Bank Details
  Widget _buildBankDetails() => _formSection(
        key: _bankFormKey,
        title: "Bank & Payment Details",
        fields: [
          _validatedField("Account Holder", accHolderC, required: true),
          _validatedField("Bank Name", bankNameC, required: true),
          _validatedField("Account Number", accNumC, digitsOnly: true),
          _validatedField("IFSC Code", ifscC, ifsc: true),
          _validatedField("UPI ID", upiC, upi: true),
        ],
      );

  // 🧩 STEP 4 — KYC Details
  Widget _buildKycDetails() => _formSection(
        key: _kycFormKey,
        title: "KYC & Verification",
        fields: [
          _validatedField("Aadhaar Number", aadhaarC, aadhaar: true),
          _validatedField("PAN Verification", panVerifyC, pan: true),
          _validatedField("KYC Status", kycStatusC),
        ],
      );

  // 🧩 STEP 5 — Warehouse Info
  Widget _buildWarehouseDetails() => _formSection(
        key: _warehouseFormKey,
        title: "Address & Warehouse Details",
        fields: [
          _validatedField("Pickup Address", pickupAddressC, required: true),
          _validatedField("Warehouse Address", warehouseAddressC, required: true),
          _validatedField("City", cityC, required: true),
          _validatedField("Pincode", pincodeC, pincode: true),
        ],
      );

  // 🧠 Generic Section
  Widget _formSection({
    required GlobalKey<FormState> key,
    required String title,
    required List<Widget> fields,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: primaryBlue)),
            const SizedBox(height: 20),
            ...fields,
          ],
        ),
      ),
    );
  }

  // ✍️ Validated TextField
  Widget _validatedField(
    String label,
    TextEditingController controller, {
    bool required = false,
    bool email = false,
    bool phone = false,
    bool gstin = false,
    bool pan = false,
    bool aadhaar = false,
    bool ifsc = false,
    bool upi = false,
    bool digitsOnly = false,
    bool pincode = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: (phone || digitsOnly || aadhaar || pincode)
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          final v = value?.trim() ?? "";
          if (required && v.isEmpty) return "This field is required";
          if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return "Invalid email";
          if (phone && (v.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(v))) return "Enter valid 10-digit phone";
          if (aadhaar && (v.length != 12 || !RegExp(r'^[0-9]+$').hasMatch(v))) return "Enter valid 12-digit Aadhaar";
          if (pincode && (v.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(v))) return "Enter valid 6-digit Pincode";
          if (gstin && !RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(v))
            return "Invalid GSTIN format";
          if (pan && !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(v)) return "Invalid PAN format";
          if (ifsc && !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(v)) return "Invalid IFSC format";
          if (upi && !RegExp(r'^[\w.\-]+@[\w]+$').hasMatch(v)) return "Invalid UPI ID";
          return null;
        },
      ),
    );
  }
}