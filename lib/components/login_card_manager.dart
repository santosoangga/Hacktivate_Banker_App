import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/auth_bloc.dart';

class ManagerLoginCard extends StatefulWidget {
  const ManagerLoginCard({super.key});

  static void clearControllers() {
    _ManagerLoginCardState.clearControllers();
  }

  @override
  State<ManagerLoginCard> createState() => _ManagerLoginCardState();
}

class _ManagerLoginCardState extends State<ManagerLoginCard> {
  static TextEditingController? _staticManagerAccessCodeController;

  final managerAccessCodeController = TextEditingController();
  bool isVerifyButtonEnabled = false;

  static void clearControllers() {
    _staticManagerAccessCodeController?.clear();
  }

  void _verifyButtonState() {
    setState(() {
      isVerifyButtonEnabled = managerAccessCodeController.text.isNotEmpty;
    });
  }

  void _onVerify() {
    final userId = "MT-01";
    final userPassword = managerAccessCodeController.text;
    context.read<AuthBloc>().add(
      AuthLoginRequested(userId: userId, userPassword: userPassword),
    );
  }

  @override
  void initState() {
    managerAccessCodeController.addListener(_verifyButtonState);
    _staticManagerAccessCodeController = managerAccessCodeController;
    super.initState();
  }

  @override
  void dispose() {
    managerAccessCodeController.dispose();
    _staticManagerAccessCodeController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: const Text('Access Code'),
      description: const Text("Input your Manager access code here."),
      footer: ShadButton(
        enabled: isVerifyButtonEnabled,
        onPressed: _onVerify,
        child: Text('Verify'),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Demo Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Access Code: kuda-liar",
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            obscureText: true,
            label: Text("Access Code"),
            controller: managerAccessCodeController,
          ),
        ],
      ),
    );
  }
}
