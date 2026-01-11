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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildGenderRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey.shade300),
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey.shade50,
          ),
          child: Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Laki-laki'),
                  value: 'Laki-laki',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Perempuan'),
                  value: 'Perempuan',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
      _showResultDialog();
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_2_rounded,
                  size: 40,
                  color: Colors.indigo,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          const Text(
            'Buat Akun Baru',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          const Text(
            'Isi form untuk mendaftar',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Masukan email anda',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email Tidak Boleh Kosong';
        }
        //simple email validate
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Format Tidak Sesuai';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Minimal 6 Karakter',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 5) {
          return 'Password minimal 5 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          child: const Text(
            'DAFTAR',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 14),
        const Text(
          'Jangan ngasal ya isinya!!',
          style: TextStyle(fontSize: 16, color: Colors.redAccent),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey.shade50,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Pilih Tanggal Lahir',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate != null ? Colors.black : Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsletterCheckbox() {
    return CheckboxListTile(
      value: _subcribeNewsletter,
      onChanged: (value) {
        setState(() {
          _subcribeNewsletter = value ?? false;
        });
      },
      title: const Text('Berlangganan Koran'),
      subtitle: const Text('Dapatkan Info Terbaru Dari Aplikasi'),
      secondary: const Icon(Icons.mail_lock_outlined),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulir Registrasi'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 10),
                _buildNameField(),
                SizedBox(height: 10),
                _buildEmailField(),
                SizedBox(height: 10),
                _buildPasswordField(),
                SizedBox(height: 10),
                _buildDatePicker(),
                SizedBox(height: 10),
                _buildGenderRadio(),
                SizedBox(height: 10),
                _buildCityDropdown(),
                SizedBox(height: 10),
                _buildNewsletterCheckbox(),
                SizedBox(height: 10),
                _buildTermsCheckbox(),
                SizedBox(height: 10),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrasi Berhasil!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultRow('Nama', _nameController.text),
              _buildResultRow('Email', _emailController.text),
              _buildResultRow(
                'Tanggal Lahir',
                '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
              _buildResultRow('Gender', _selectedGender!),
              _buildResultRow('Kota', _selectedCity ?? '-'),
              _buildResultRow(
                'Newsletter',
                _subcribeNewsletter ? 'ya' : 'tidak',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _agreeToTerm,
      onChanged: (value) {
        setState(() {
          _agreeToTerm = value ?? false;
        });
      },
      title: const Text('Saya menyetujui syarat dan ketentuan'),
      subtitle: const Text('Wajib di centang untuk melanjutkan'),
      secondary: const Icon(Icons.verified_user),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.green,
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCity,
      decoration: InputDecoration(
        labelText: 'Kota',
        prefixIcon: const Icon(Icons.location_city_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey.shade50,
      ),
      hint: const Text('Pilihlah Kota'),
      items: _cities.map((city) {
        return DropdownMenuItem(value: city, child: Text(city));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        hintText: 'Masukan Nama Lengkap',
        prefixIcon: const Icon(Icons.person_4_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama Tidak Boleh Kosong';
        }
        if (value.length < 3) {
          return 'Nama Minimal 3 Karakter';
        }
        return null;
      },
    );
  }
}
