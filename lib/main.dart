import 'package:blog_app/core/comman/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/blog/presentation/bloc/blog_bloc.dart';

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
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<
            AuthBloc>(), // given datatype to have the service locator select the dependency
        // AuthBloc(
        //     userSignUp: UserSignUp(AuthRepositoryImpl(
        //         AuthRemoteDataSourceImpl(supabase.client))))),
      ),
      
      BlocProvider(create: (_) => serviceLocator<BlogBloc>(),),
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
      home: BlocSelector<AuthBloc, AuthState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (
          context,
          isLoggedIn,
          //this is the state  which is repas isLogged in state
        ) {
          if (isLoggedIn == true) {
            // navigate to home page when is logged in
            return const BlogPage();
          }
          return const LogInPage();
        },
      ),
    );
  }
}
