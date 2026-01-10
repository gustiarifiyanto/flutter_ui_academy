import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  //Form Key - Untuk Validasi Form
  final _formKey = GlobalKey<FormState>();

  //Text Controller - Untuk Ambil Values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  //Form State Variable
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedCity;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerm = false;
  bool _subcribeNewsletter = false;

  //Data Untuk Dropdown
  final List<String> _cities = [
    'Jakarta',
    'Medan',
    'Bandung',
    'Yogyakarta',
    'Cirebon',
  ];

  @override
  void dispose() {
    //Jangan lupa di dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  //DatePicker Function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectDate(context)) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //Form Submission

  void submitForm() {
    //validasi form
    if (_formKey.currentState!.validate()) {
      //Cek CheckBox Term
      if (!_agreeToTerm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      //Cek Tanggal Lahir

      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silahkan pilih tanggal lahir'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      //Cek Gender

      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silahkan Pilih Jenis Kelamin'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Formulir Registrasi'),
    
    ));
  }
}
