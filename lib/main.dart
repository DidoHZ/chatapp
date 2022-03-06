import 'package:chatapp/data/repositories/AuthRepository.dart';
import 'package:chatapp/data/repositories/chatRepository.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'view/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: RepositoryProvider(
      create: (context) => ChatRepository(),
      child: BlocProvider(
            create: (context) =>
                ChatsCubit(repo: context.read<ChatRepository>()),
        child:GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
     ))
    );
  }
}
