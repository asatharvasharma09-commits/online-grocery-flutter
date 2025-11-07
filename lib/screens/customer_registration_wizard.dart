import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer_registration_success_screen.dart';

class CustomerRegistrationWizard extends StatefulWidget {
  const CustomerRegistrationWizard({super.key});

  @override
  State<CustomerRegistrationWizard> createState() => _CustomerRegistrationWizardState();
}

class _CustomerRegistrationWizardState extends State<CustomerRegistrationWizard> {
  final PageController _pageController = PageController();
  final Color primaryBlue = const Color(0xFF3D8BF2);
  int _currentStep = 0;
  bool _isSaving = false;

  final _personalFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _accountFormKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final cityC = TextEditingController();
  final pincodeC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addressC.dispose();
    cityC.dispose();
    pincodeC.dispose();
    passwordC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _personalFormKey.currentState?.validate() ?? false;
      case 1:
        return _addressFormKey.currentState?.validate() ?? false;
      case 2:
        return _accountFormKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  Future<void> _saveCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customer_name', nameC.text.trim());
    await prefs.setString('customer_email', emailC.text.trim());
    await prefs.setString('customer_phone', phoneC.text.trim());
    await prefs.setString('customer_address', addressC.text.trim());
    await prefs.setString('customer_city', cityC.text.trim());
    await prefs.setString('customer_pincode', pincodeC.text.trim());
  }

  void _nextStep() async {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        await _saveCustomerData();
        _submitRegistration();
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

  Future<void> _submitRegistration() async {
    setState(() => _isSaving = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registration Successful! Redirecting..."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CustomerRegistrationSuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Customer Registration"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _progressBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep(
                  "Personal Information",
                  Icons.person_outline,
                  _personalFormKey,
                  [
                    _validatedField("Full Name", nameC, required: true),
                    _validatedField("Email", emailC, email: true),
                    _validatedField("Phone", phoneC, phone: true),
                  ],
                ),
                _buildStep(
                  "Address Details",
                  Icons.location_on_outlined,
                  _addressFormKey,
                  [
                    _validatedField("Full Address", addressC, required: true),
                    _validatedField("City", cityC, required: true),
                    _validatedField("Pincode", pincodeC, pincode: true),
                  ],
                ),
                _buildStep(
                  "Account Setup",
                  Icons.lock_outline,
                  _accountFormKey,
                  [
                    _validatedField("Password", passwordC, password: true),
                    _validatedField("Confirm Password", confirmC,
                        confirmPassword: passwordC),
                  ],
                ),
              ],
            ),
          ),
          _navigationButtons(),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LinearProgressIndicator(
        value: (_currentStep + 1) / 3,
        backgroundColor: Colors.grey[300],
        color: primaryBlue,
        minHeight: 8,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _navigationButtons() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text("Back"),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                    _currentStep == 2
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward_ios_rounded,
                    color: Colors.white),
                onPressed: _isSaving ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: _isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        _currentStep == 2 ? "Submit & Register" : "Next",
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

  Widget _buildStep(
    String title,
    IconData icon,
    GlobalKey<FormState> key,
    List<Widget> fields,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: primaryBlue, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ]),
            const SizedBox(height: 20),
            ...fields,
          ],
        ),
      ),
    );
  }

  Widget _validatedField(
    String label,
    TextEditingController controller, {
    bool required = false,
    bool email = false,
    bool phone = false,
    bool pincode = false,
    bool password = false,
    TextEditingController? confirmPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: password || confirmPassword != null,
        keyboardType: phone || pincode ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          final v = value?.trim() ?? '';
          if (required && v.isEmpty) return "This field is required";
          if (email && v.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
            return "Invalid email";
          if (phone && (v.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(v)))
            return "Enter valid phone";
          if (pincode && (v.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(v)))
            return "Enter valid pincode";
          if (password && v.length < 6) return "At least 6 characters";
          if (confirmPassword != null && v != confirmPassword.text)
            return "Passwords do not match";
          return null;
        },
      ),
    );
  }
}