import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_logo.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 1 - Login. UI only in Step 2.2: a valid form simply opens the
/// Home Feed, real authentication comes in Step 3.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }
    AppStateScope.read(context).selectTab(0);
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUtory'),
        automaticallyImplyLeading: false,
      ),
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
                  const SizedBox(height: AppSpacing.lg),
                  const Center(child: AppLogo(size: 96)),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'The campus forum for Sabancı students',
                    style: AppTextStyles.bodyMuted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      return Validators.requiredField(value, 'Password');
                    },
                    onFieldSubmitted: (String value) => _logIn(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(label: 'Log In', onPressed: _logIn),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.signUp);
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
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
