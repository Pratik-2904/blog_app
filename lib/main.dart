import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TO initialize the supabase make main asynchronous
void main() async {
  //Always use this to endure flutter bindings are proper
  //if there are any await or synchronous methods before runApp
  WidgetsFlutterBinding.ensureInitialized();
  //use await to initialize the supabase
  //Gives initialize the supabase for later use thus store in a variable
  final supabase = await Supabase.initialize(
    //Supabase Project Url
    url: AppSecrets.supabaseUrl,
    //Supabase api key
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (_) => AuthBloc(
              userSignUp: UserSignUp(AuthRepositoryImpl(
                  AuthRemoteDataSourceImpl(supabase.client))))),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog_app',
      theme: AppTheme.DarkThemeMode,
      home: const LogInPage(),
    );
  }
}
