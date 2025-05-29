import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:h8_fli_geo_maps_starter/components/login_card_staff.dart';
import 'package:h8_fli_geo_maps_starter/components/login_card_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../manager/auth_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _activeTab = 'staff';

  void _onTabChanged(String value) {
    setState(() {
      _activeTab = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (_activeTab == 'staff') {
              Navigator.pushNamed(context, '/home-staff');
            } else if (_activeTab == 'manager') {
              Navigator.pushNamed(context, '/home-manager');
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid credentials')),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: ShadTabs<String>(
                value: _activeTab,
                onChanged: _onTabChanged,
                tabBarConstraints: const BoxConstraints(maxWidth: 400),
                contentConstraints: const BoxConstraints(maxWidth: 400),
                tabs: [
                  ShadTab(
                    value: 'staff',
                    content: StaffLoginCard(),
                    child: const Text('Staff'),
                  ),
                  ShadTab(
                    value: 'manager',
                    content: ManagerLoginCard(),
                    child: const Text('Manager'),
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
