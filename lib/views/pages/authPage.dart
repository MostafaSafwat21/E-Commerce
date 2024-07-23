import 'package:ecommerce/controllers/Auth_Controller.dart';
import 'package:ecommerce/utilities/assets.dart';
import 'package:ecommerce/utilities/enums.dart';
import 'package:ecommerce/views/widgets/main_button.dart';
import 'package:ecommerce/views/widgets/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_dialog.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
  Future<void> _submit(AuthController model) async {
    try {
      await model.submit();
      if (!mounted) return;
    } catch (e) {
      MainDialog(context: context, title: 'Error', content: e.toString()).showAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AuthController>(
      builder: (_, model, __) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 32,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.authFormType == AuthFormType.login
                            ? 'Login'
                            : 'Register',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      if (model.authFormType == AuthFormType.register)
                        TextFormField(
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(passwordFocusNode),
                          textInputAction: TextInputAction.next,
                          focusNode: nameFocusNode,
                          controller: nameController,
                          onChanged: model.updateName,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                          ),
                        ),
                      if (model.authFormType == AuthFormType.register)
                        const SizedBox(
                          height: 24.0,
                        ),
                      TextFormField(
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(nameFocusNode),
                        textInputAction: TextInputAction.next,
                        focusNode: emailFocusNode,
                        controller: emailController,
                        onChanged: model.updateEmail,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      TextFormField(
                        onChanged: model.updatePassword,
                        textInputAction: TextInputAction.done,
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (model.authFormType == AuthFormType.login)
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: const Text(
                              'Forget your password?',
                            ),
                            onTap: () {},
                          ),
                        ),
                      const SizedBox(
                        height: 24,
                      ),
                      MainButton(
                        text: model.authFormType == AuthFormType.login
                            ? 'Login'
                            : 'Register',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            _submit(model);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Text(
                            model.authFormType == AuthFormType.login
                                ? 'Don\'t have an account? Register'
                                : 'Have an account? Login',
                          ),
                          onTap: () {
                            model.toggleFormType();
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          model.authFormType == AuthFormType.login
                              ? 'or login to app with'
                              : 'or register with',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialMediaButton(
                            iconName: AppAssets.facebookIcon,
                            onPress: () {},
                          ),
                          const SizedBox(width: 16.0),
                          SocialMediaButton(
                            iconName: AppAssets.googleIcon,
                            onPress: () {},
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
