import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TO initialize the supabase make main asynchronous
void main() async {
  //Always use this to endure flutter bindings are proper
  //if there are any await or synchronous methods before runApp
  WidgetsFlutterBinding.ensureInitialized();
  //use await to initialize the supabase
  //Gives initialize the supabase for later use thus store in a variable

  // final supabase = await Supabase.initialize(
  //   //Supabase Project Url
  //   url: AppSecrets.supabaseUrl,       //instead of using this using dependency injection for it
  //   //Supabase api key
  //   anonKey: AppSecrets.supabaseAnonKey,
  // );
  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<
            AuthBloc>(), // given datatype to have the service locator select the dependency
        // AuthBloc(
        //     userSignUp: UserSignUp(AuthRepositoryImpl(
        //         AuthRemoteDataSourceImpl(supabase.client))))),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog_app',
      theme: AppTheme.darkThemeMode,
      home: const LogInPage(),
    );
  }
}
