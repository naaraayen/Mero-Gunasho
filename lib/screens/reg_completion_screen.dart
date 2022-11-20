import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../widgets/custom_text.dart';

// Page that loads up after user finishes picking up or registering a complain
class RegisterCompletionScreen extends StatelessWidget {
  static const routeName = '/RegisterCompletionScreen';
  const RegisterCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // isSucceeded = succeed or failed
    final isSucceeded = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(isSucceeded == 'succeed'
              ? 'Thank You For Submitting Your Complain. We Will Get Back To Your Problem Soon.'
              : 'Unable To submit Your Complain. Try Again Later'),
          Flexible(
            flex: 20,
            child: Image.asset(
              isSucceeded == 'succeed'
                  ? 'assets/logos/mero_gunasho_reg_completion.png'
                  : 'assets/logos/mero_gunasho_reg_failed.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 40))),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, Home.routeName,
                    ModalRoute.withName(Home.routeName));
                // Navigator.of(context)
                //     .popUntil(ModalRoute.withName(Home.routeName));
              },
              child: const Text('Back To Home'))
        ],
      ),
    ));
  }
}
