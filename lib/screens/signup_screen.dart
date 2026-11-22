import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/dialogs/confirmation_dialog.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 2 - Sign Up. A form with four fields and inline validation.
/// A valid submission shows a confirmation dialog and opens the Home Feed.
/// No real account is created in Step 2.2.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    final AppState state = AppStateScope.read(context);
    final NavigatorState navigator = Navigator.of(context);
    final String username = _usernameController.text.trim();
    FocusScope.of(context).unfocus();

    state.updateProfile(
      username: username,
      email: _emailController.text.trim().toLowerCase(),
    );

    await showConfirmationDialog(
      context,
      title: 'Account created',
      message: 'Welcome to SUtory, @$username!',
      buttonLabel: 'Continue',
    );

    state.selectTab(0);
    navigator.pushNamedAndRemoveUntil(
      AppRoutes.main,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: ResponsiveCenter(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LabeledTextField(
                    label: 'Username',
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.username,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledTextField(
                    label: 'University email',
                    controller: _emailController,
                    hintText: 'name${Validators.universityDomain}',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.universityEmail,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledTextField(
                    label: 'Confirm password',
                    controller: _confirmController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      return Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      );
                    },
                    onFieldSubmitted: (String value) => _signUp(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(label: 'Sign Up', onPressed: _signUp),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Already have an account? Log in',
                      textAlign: TextAlign.center,
                    ),
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
