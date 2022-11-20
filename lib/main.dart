import 'package:flutter/material.dart';
import './providers/auth.dart';
import './providers/temporary_data.dart';
import './screens/auth_screen.dart';
import './screens/reg_complain_screen_1.dart';
import './screens/reg_complain_screen_2.dart';
import './screens/reg_complain_screen_3.dart';
import './screens/reg_completion_screen.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './providers/complain.dart';

// TODO : Yet to implemet admin setup
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Authentication()),
        ChangeNotifierProxyProvider<Authentication, Complain>(
            create: (ctx) => Complain(
                  Provider.of<Authentication>(ctx, listen: false).tokenId,
                  Provider.of<Authentication>(ctx, listen: false).userId,
                ),
            update: ((ctx, auth, previousComplain) =>
                Complain(auth.tokenId, auth.userId))),
        ChangeNotifierProvider(create: (ctx) => TemporaryData())
      ],
      child: MaterialApp(
        title: 'Mero Gunasho',
        debugShowCheckedModeBanner: false,
        // TODO: Use proper theme
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        //home: Home(),
        routes: {
          '/': (ctx) => AuthScreen(),
          Home.routeName: (ctx) => Home(),
          RegisterComplainScreen1.routeName: (ctx) => RegisterComplainScreen1(),
          RegisterComplainScreen2.routeName: (ctx) => RegisterComplainScreen2(),
          RegisterComplainScreen3.routeName: (ctx) => RegisterComplainScreen3(),
          RegisterCompletionScreen.routeName: (ctx) =>
              RegisterCompletionScreen(),
        },
      ),
    );
  }
}
