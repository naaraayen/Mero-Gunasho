import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temporary_data.dart';
import '../screens/home_screen.dart';
import '../providers/complain.dart';
import '../screens/reg_completion_screen.dart';
import '../widgets/custom_text.dart';
import '../widgets/styled_title.dart';

// Page that loads up after user chooses to register a new complain
class RegisterComplainScreen3 extends StatefulWidget {
  static const routeName = '/RegisterComplainScreen3';
  const RegisterComplainScreen3({super.key});

  @override
  State<RegisterComplainScreen3> createState() =>
      _RegisterComplainScreen3State();
}

class _RegisterComplainScreen3State extends State<RegisterComplainScreen3> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  final Map<String, String> complainData = {
    'title': '',
    'decription': '',
  };
  
  // This method checks the validation of the textfield and pushes to completion screen
  Future<void> submitForm(int wardNo, String category) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    try {
      await Provider.of<Complain>(context, listen: false).addComplain(
          title: complainData['title'].toString(),
          description: complainData['description'].toString(),
          wardNo: wardNo,
          category: category);
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context,
          RegisterCompletionScreen.routeName, ModalRoute.withName(Home.routeName), arguments: 'succeed');
    } catch (error) {
      Navigator.pushNamedAndRemoveUntil(context,
          RegisterCompletionScreen.routeName, ModalRoute.withName(Home.routeName), arguments: 'failed');

    }
  }

  @override
  Widget build(BuildContext context) {
    final tempData = Provider.of<TemporaryData>(context, listen: false);
    final wardNo = tempData.wardNo;
    final category = tempData.category;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StyledTitle(),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black26,
                    )),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // Textfield for title
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText('Enter The Complain Title'),
                      CustomTextField(
                        title: 'Enter A Brief Title Of Your Complain',
                        onSaved: (value) {
                          if (value != null) {
                            complainData['title'] = value;
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Title cannot be empty';
                            } else if (value.length < 4) {
                              return 'Title too short';
                            } else if (value.length > 30) {
                              return 'Title too long';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),

                      // Textfield for description
                      const CustomText(
                        'Enter The Description Of The Complain',
                      ),
                      CustomTextField(
                        maxLines: 3,
                        title:
                            'Enter A Brief Description That Supports Your Complain',
                        onSaved: (value) {
                          if (value != null) {
                            complainData['description'] = value;
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Description cannot be empty';
                            } else if (value.length < 10) {
                              return 'Description too short';
                            } else if (value.length > 300) {
                              return 'Description too long';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Submit button
                  ElevatedButton(
                      onPressed: () {
                        // Calls submitForm method and pushes to new screen if validation succeeds
                        submitForm(int.parse(wardNo), category);
                      },
                      style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 40))),
                      child: _isLoading == true
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          : const Text('Submit A Complain'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Customised TextField
class CustomTextField extends StatelessWidget {
  final int maxLines;
  final String title;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  const CustomTextField(
      {super.key,
      this.maxLines = 1,
      required this.title,
      required this.onSaved,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        hintText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
