import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/data/repositories/AuthRepository.dart';
import 'package:chatapp/logic/bloc/Authentication/signup/signup_bloc.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            SignupBloc(authRepo: context.read<AuthRepository>()),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _signUpForm(),
            _showLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          } else if (formStatus is SubmissionSuccess) {
            Navigator.of(context).pushReplacementNamed(homePage);
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                _emailField(),
                _passwordField(),
                _firstNameField(),
                _lastNameField(),
                _signUpButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) =>
            state.isValidUsername ? null : 'Username is to short',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.mail),
          hintText: 'Email',
        ),
        validator: (value) => state.isValidEmail ? null : 'Invalid email',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupEmailChanged(email: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _firstNameField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.sort_by_alpha_rounded),
          hintText: 'First Name',
        ),
        validator: (value) =>
            state.isValidfirstName ? null : 'First Name is too short',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupfirstNameChanged(firstName: value),
            ),
      );
    });
  }

  Widget _lastNameField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.sort_by_alpha_rounded),
          hintText: 'Last Name',
        ),
        validator: (value) =>
            state.isValidlastName ? null : 'Last Name is too short',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignuplastNameChanged(lastName: value),
            ),
      );
    });
  }

  Widget _signUpButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignupBloc>().add(SignupSubmitted());
                  }
                },
                child: const Text('Sign Up'),
              );
      }),
    );
  }

  Widget _showLoginButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: const Text('Already have an account? Sign in.'),
        onPressed: () => Navigator.of(context).pushReplacementNamed(loginPage),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
