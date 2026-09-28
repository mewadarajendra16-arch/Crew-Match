import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';
import '../../widgets.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  const RegisterScreen({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  String _role = 'organiser';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty || _password.text.trim().isEmpty) {
      setState(() => _error = 'Please fill in all required fields');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await AuthService.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text.trim(),
      role: _role,
      phone: _phone.text.trim(),
    );
    setState(() => _loading = false);

    if (success && mounted) {
      toast(context, 'Account created successfully!');
      Navigator.pop(context);
      widget.onRegisterSuccess();
    } else if (mounted) {
      setState(() => _error = 'Registration failed. Email might already exist.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Join CrewMatch', style: ts(24, w: FontWeight.w800, color: C.navy)),
                Text('Select your account role and complete registration', style: ts(13, color: C.slate600)),
                const SizedBox(height: 20),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: C.redBg, borderRadius: BorderRadius.circular(6)),
                    child: Text(_error!, style: ts(13, color: C.red, w: FontWeight.w600)),
                  ),
                  const SizedBox(height: 14),
                ],
                Text('Account Type / Role', style: ts(13, w: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text('Organiser', style: ts(13, w: FontWeight.w700)),
                        selected: _role == 'organiser',
                        selectedColor: C.blueHigh,
                        onSelected: (selected) {
                          if (selected) setState(() => _role = 'organiser');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceChip(
                        label: Text('Event Worker', style: ts(13, w: FontWeight.w700)),
                        selected: _role == 'worker',
                        selectedColor: C.blueHigh,
                        onSelected: (selected) {
                          if (selected) setState(() => _role = 'worker');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Full Name *', style: ts(13, w: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    hintText: 'John Doe',
                    filled: true,
                    fillColor: C.blue,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Email Address *', style: ts(13, w: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'john@example.com',
                    filled: true,
                    fillColor: C.blue,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Password *', style: ts(13, w: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    filled: true,
                    fillColor: C.blue,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Phone Number', style: ts(13, w: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '9876543210',
                    filled: true,
                    fillColor: C.blue,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  _loading ? 'Creating account...' : 'Complete Registration',
                  icon: Icons.person_add,
                  onPressed: _loading ? null : _handleRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
