import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/data/repositories/AuthRepository.dart';
import 'package:chatapp/view/chats.dart';
import 'package:chatapp/view/login.dart';
import 'package:chatapp/view/profile.dart';
import 'package:chatapp/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat.dart';
class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
          return MaterialPageRoute(
              builder: (context) => RepositoryProvider.of<AuthRepository>(context).isUserLoggedIn()
                  ? const ChatPage()
                  : const LoginPage());
      case homePage:
        return MaterialPageRoute(
            builder: (_) => const ChatPage());
      case loginPage:
        return MaterialPageRoute(
            builder: (_) => const LoginPage());
      case signupPage:
        return MaterialPageRoute(
            builder: (_) => const SignUpPage());
      case chatsPage:
        return MaterialPageRoute(
            builder: (_) => const ChatPage());
      case chatPage:
        return MaterialPageRoute(
            builder: (_) => Chat(user: settings.arguments));
      case profilePage:
        return MaterialPageRoute(
            builder: (_) => const ProfilePage());
      default:
        return null;
    }
  }
}
