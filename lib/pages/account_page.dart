import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app_state.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/utils.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
  }

  void _updateEmail() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final success = await _authService.updateEmail(
        _emailController.text,
        _passwordController.text, // Re-autenticação necessária
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'E-mail de verificação enviado! Por favor, verifique sua caixa de entrada.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao atualizar o e-mail.')),
        );
      }
    }
  }

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final success = await _authService.updatePassword(
        _passwordController.text,
        _newPasswordController.text,
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso!')),
        );
        _passwordController.clear();
        _newPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao alterar a senha.')),
        );
      }
    }
  }

  void _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Conta'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(appState.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: 'E-mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Por favor, insira um e-mail válido.';
                              }
                              return null;
                            },
                            onChanged: (value) => setState(() {}),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: (_emailController.text !=
                                    FirebaseAuth.instance.currentUser?.email)
                                ? _updateEmail
                                : null,
                            child: const Text('Alterar E-mail'),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Senha Atual'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _newPasswordController,
                            decoration:
                                const InputDecoration(labelText: 'Nova Senha'),
                            obscureText: true,
                            validator: validatePassword,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _updatePassword,
                            child: const Text('Alterar Senha'),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Sair'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
