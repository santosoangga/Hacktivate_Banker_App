import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final userIdController = TextEditingController();
  final userPasswordController = TextEditingController();
  bool _isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = userIdController.text.isNotEmpty && userPasswordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    userIdController.addListener(_updateButtonState);
    userPasswordController.addListener(_updateButtonState);
    super.initState();
  }

  @override
  dispose() {
    userIdController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ShadTabs<String>(
            value: 'staff',
            tabBarConstraints: const BoxConstraints(maxWidth: 400),
            contentConstraints: const BoxConstraints(maxWidth: 400),
            tabs: [
              ShadTab(
                value: 'staff',
                content: ShadCard(
                  title: const Text('Access Code'),
                  description: const Text("Input your Staff Id & access code here."),
                  footer: ShadButton(
                    enabled: _isButtonEnabled,
                    child: Text('Verify'),
                    onPressed: () {
                      final userId = userIdController.text;
                      final userPassword = userPasswordController.text;

                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Staff Code: macan-gunung",
                          style: TextStyle(fontSize: 10, color: Colors.green, ),
                        ),
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        label: Text("Staff Code"),
                        leading: Text("ST-"),
                        controller: userIdController,
                      ),
                      const SizedBox(height: 8),
                      ShadInputFormField(
                        label: Text("Access Code"),
                        obscureText: true,
                        controller: userPasswordController,
                      ),
                    ],
                  ),
                ),
                child: const Text('Staff'),
              ),
              ShadTab(
                value: 'manager',
                content: ShadCard(
                  title: const Text('Access Code'),
                  description: const Text(
                    "Input your Manager access code here.",
                  ),
                  footer: ShadButton(
                    child: Text('Verify'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  child: ShadInputFormField(
                    obscureText: true,
                    description: Text(
                      "Manager Code: kuda-poni",
                      style: TextStyle(fontSize: 10, color: Colors.green),
                    ),
                  ),
                ),
                child: const Text('Manager'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
