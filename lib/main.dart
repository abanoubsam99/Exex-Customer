import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/Helper/BlocProviders.dart';
import 'data/network/token_manager.dart';
import 'data/network/dio_client.dart';
import 'presentation/splash/pages/splash_screen.dart';
// import 'app/compat/getx_compat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up foundational services
  // final tokenManager = TokenManager();
  // final dioClient = DioClient(tokenManager);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(MyApp(
    // tokenManager: tokenManager,
    // dioClient: dioClient,
  ));
}
class MyApp extends StatelessWidget {
  // final TokenManager tokenManager;
  // final DioClient dioClient;

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: BlocProviders.providers,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // navigatorKey: appNavigatorKey,
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            locale: const Locale('ar'),
            title: 'EVEX Customer',
            theme: ThemeData(
              primaryColor: const Color(0xFFF38B4A),
              fontFamily: 'Almarai',
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
