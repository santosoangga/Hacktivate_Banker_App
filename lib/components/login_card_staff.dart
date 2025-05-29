import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/auth_bloc.dart';

class StaffLoginCard extends StatefulWidget {
  const StaffLoginCard({super.key});

  @override
  State<StaffLoginCard> createState() => _StaffLoginCardState();
}

class _StaffLoginCardState extends State<StaffLoginCard> {
  final staffIdController = TextEditingController();
  final staffAccessCodeController = TextEditingController();
  bool isVerifyButtonEnabled = false;

  void _verifyButtonState() {
    setState(() {
      isVerifyButtonEnabled =
          staffIdController.text.isNotEmpty &&
          staffAccessCodeController.text.isNotEmpty;
    });
  }

  void _onVerify() {
    final userId = "ST-${staffIdController.text}";
    final userPassword = staffAccessCodeController.text;
    context.read<AuthBloc>().add(
      AuthLoginRequested(userId: userId, userPassword: userPassword),
    );
  }

  @override
  void initState() {
    staffIdController.addListener(_verifyButtonState);
    staffAccessCodeController.addListener(_verifyButtonState);
    super.initState();
  }

  @override
  void dispose() {
    staffIdController.dispose();
    staffAccessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: const Text('Access Code'),
      description: const Text("Input your Staff Id & access code here."),
      footer: ShadButton(
        enabled: isVerifyButtonEnabled,
        onPressed: _onVerify,
        child: Text('Verify'),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                    "Staff Code: ST-01/ST-02",
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                  Text(
                    "Access Code: macan-gunung",
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ShadInputFormField(
            label: Text("Staff Code"),
            leading: Text("ST-"),
            controller: staffIdController,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: Text("Access Code"),
            obscureText: true,
            controller: staffAccessCodeController,
          ),
        ],
      ),
    );
  }
}
