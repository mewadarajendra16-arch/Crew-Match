import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';
import '../../widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'organiser@crewmatch.com');
  final _password = TextEditingController(text: 'password123');
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await AuthService.login(_email.text.trim(), _password.text.trim());
    setState(() => _loading = false);

    if (success && mounted) {
      toast(context, 'Login successful! Welcome back.');
      widget.onLoginSuccess();
    } else if (mounted) {
      setState(() => _error = 'Invalid email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Logo(crew: true, size: 64)),
                  const SizedBox(height: 16),
                  Center(
                    child: Text('CrewMatch Access', style: ts(24, w: FontWeight.w800, color: C.navy)),
                  ),
                  Center(
                    child: Text('Sign in to manage shifts, crew, and queue telemetry',
                        textAlign: TextAlign.center, style: ts(13, color: C.slate600)),
                  ),
                  const SizedBox(height: 24),
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: C.redBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(_error!, style: ts(13, color: C.red, w: FontWeight.w600)),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Text('Email Address', style: ts(13, w: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'name@organization.com',
                      filled: true,
                      fillColor: C.blue,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Password', style: ts(13, w: FontWeight.w600)),
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
                  const SizedBox(height: 20),
                  AppButton(
                    _loading ? 'Signing in...' : 'Sign In',
                    icon: Icons.login,
                    onPressed: _loading ? null : _handleLogin,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: ts(13, color: C.slate600)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(onRegisterSuccess: widget.onLoginSuccess),
                            ),
                          );
                        },
                        child: Text('Register', style: ts(13, w: FontWeight.w700, color: C.primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
