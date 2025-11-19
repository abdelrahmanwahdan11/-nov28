import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../controllers/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final auth = ControllerScope.of(context).authController;
  late final tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.translate('app_name'),
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              TabBar(
                controller: tabController,
                labelColor: theme.colorScheme.primary,
                tabs: [
                  Tab(text: loc.translate('login')),
                  Tab(text: loc.translate('signup')),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _LoginForm(auth: auth),
                    _SignupForm(auth: auth),
                  ],
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: auth.isGuest,
                builder: (_, isGuest, __) {
                  return TextButton.icon(
                    onPressed: () async {
                      await auth.continueAsGuest();
                      if (!mounted) return;
                      Navigator.of(context)
                          .pushReplacementNamed('/home_shell');
                    },
                    icon: const Icon(IconlyLight.profile),
                    label: Text(loc.translate('guest')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Form(
      key: auth.loginKey,
      child: ListView(
        padding: const EdgeInsets.only(top: 24),
        children: [
          TextFormField(
            controller: auth.loginEmail,
            decoration: InputDecoration(labelText: loc.translate('email')),
            validator: (value) =>
                value != null && value.contains('@') ? null : 'Enter email',
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: auth.obscureLogin,
            builder: (_, obscure, __) {
              return TextFormField(
                controller: auth.loginPassword,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: loc.translate('password'),
                  suffixIcon: IconButton(
                    icon: Icon(obscure ? IconlyLight.show : IconlyLight.hide),
                    onPressed: () =>
                        auth.obscureLogin.value = !auth.obscureLogin.value,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.translate('forgot_password'))),
                );
              },
              child: Text(loc.translate('forgot_password')),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (auth.loginKey.currentState?.validate() ?? false) {
                auth.markSignedIn();
                Navigator.of(context).pushReplacementNamed('/home_shell');
              }
            },
            child: Text(loc.translate('login')),
          ),
        ],
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Form(
      key: auth.signupKey,
      child: ListView(
        padding: const EdgeInsets.only(top: 24),
        children: [
          TextFormField(
            controller: auth.signupEmail,
            decoration: InputDecoration(labelText: loc.translate('email')),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: auth.obscureSignup,
            builder: (_, obscure, __) {
              final password = auth.signupPassword.text;
              final strength = auth.passwordStrengthLabel(password);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: auth.signupPassword,
                    obscureText: obscure,
                    onChanged: (_) => auth.signupKey.currentState?.validate(),
                    decoration: InputDecoration(
                      labelText: loc.translate('password'),
                      suffixIcon: IconButton(
                        icon:
                            Icon(obscure ? IconlyLight.show : IconlyLight.hide),
                        onPressed: () =>
                            auth.obscureSignup.value = !auth.obscureSignup.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: auth
                                .passwordStrengthColor(password)
                                .withOpacity(.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: FractionallySizedBox(
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: password.length / 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: auth.passwordStrengthColor(password),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(strength),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              auth.markSignedIn();
              Navigator.of(context).pushReplacementNamed('/home_shell');
            },
            child: Text(loc.translate('signup')),
          ),
        ],
      ),
    );
  }
}
