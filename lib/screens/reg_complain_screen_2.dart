import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temporary_data.dart';
import '../screens/home_screen.dart';
import '../screens/reg_completion_screen.dart';
import '../providers/complain.dart';
import '../widgets/custom_text.dart';
import '../widgets/styled_title.dart';
import '../widgets/complain_item.dart' as ci;
import '../screens/reg_complain_screen_3.dart';

// Page that loads up upon selecting ward and category
class RegisterComplainScreen2 extends StatefulWidget {
  static const routeName = '/RegisterComplainScreen2';
  const RegisterComplainScreen2({super.key});

  @override
  State<RegisterComplainScreen2> createState() =>
      _RegisterComplainScreen2State();
}

class _RegisterComplainScreen2State extends State<RegisterComplainScreen2> {
  late Future complainFuture;
  var isLoading = false;
  int? selectedIndex = null;
  bool isExistingComplainSelected = false;
  var prevValue = null;
  var selectedComplain = '';

  @override
  void initState() {
    // Future reference
    complainFuture =
        Provider.of<Complain>(context, listen: false).fetchComplains(false);
    super.initState();
  }

  // Method that allows picking up the existing complain (if any)
  void toggleSelection(int index, String complainId) {
    if (prevValue == index) {
      setState(() {
        isExistingComplainSelected = !isExistingComplainSelected;
        prevValue = null;
      });
      return;
    }
    setState(() {
      selectedIndex = index;
      isExistingComplainSelected = true;
    });
    selectedComplain = complainId;
    prevValue = selectedIndex;
  }

  // Gets invoked if user picks up exiting complain
  void onPickingExistingComplain() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Complain>(context, listen: false)
          .updateComplain(selectedComplain);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          RegisterCompletionScreen.routeName,
          ModalRoute.withName(Home.routeName),
          arguments: 'succeed');
    } catch (_) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          RegisterCompletionScreen.routeName,
          ModalRoute.withName(Home.routeName),
          arguments: 'failed');
    }
  }

  // Gets invoked if user chooses to make a new one
  void onMakingNewComplain() {
    Navigator.pushNamed(context, RegisterComplainScreen3.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final tempData = Provider.of<TemporaryData>(context, listen: false);
    final getWardList = Provider.of<Complain>(context, listen: false)
        .filterComplain(int.parse(tempData.wardNo), tempData.category);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'There are these complains on the cagegory ${tempData.category} on Ward no ${tempData.wardNo}. Is your complain same as the other reported compain?',
                  ),
                  const CustomText(
                      'If you are having the same complain as one of the already listed complain please select the complain.',
                      getWeight: FontWeight.normal),
                  const SizedBox(
                    height: 5.0,
                  ),

                  // Loads up existing complains of the selected ward in selected category (if any)
                  getWardList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/logos/mero_gunasho_complain_not_found.png',
                                fit: BoxFit.cover,
                              ),
                              CustomText(
                                  'No Existing Complains Found on the category ${tempData.category} on Ward no ${tempData.wardNo}. You can proceed further to make a new complain.'),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: min(getWardList.length * 145, 435),
                          child: FutureBuilder(
                              future: complainFuture,
                              builder: ((ctx, dataSnapshot) {
                                if (dataSnapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (dataSnapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                          'Unable To Fetch Your Complains'),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: getWardList.length,
                                    itemBuilder: ((ctx, index) {
                                      return InkWell(
                                        onTap: () {
                                          toggleSelection(
                                              index, getWardList[index].id);
                                        },
                                        child: ci.ComplainItem(
                                            getWardList[index].id,
                                            selectedIndex == index
                                                ? (isExistingComplainSelected
                                                    ? Colors.grey
                                                    : Colors.white)
                                                : Colors.white,
                                            false),
                                      );
                                    }),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              })),
                        ),

                  // getWardList.isEmpty
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(20.0),
                  //         child: CustomText(
                  //             'No Existing Complains Found on the category ${tempData.category} on Ward no ${tempData.wardNo}. You can proceed further to make a new complain.'),
                  //       )
                  //     : SizedBox(
                  //         height: min(getWardList.length * 140, 405),
                  //         child: ListView.builder(
                  //             itemCount: getWardList.length,
                  //             itemBuilder: ((ctx, index) {
                  //               return InkWell(
                  //                   onTap: () {
                  //                     //isSelected = false;
                  //                     toggleSelection(
                  //                         index, getWardList[index].id);
                  //                   },
                  //                   child: ci.ComplainItem(
                  //                       getWardList[index].id,
                  //                       selectedIndex == index
                  //                           ? (isSelected
                  //                               ? Colors.grey
                  //                               : Colors.white)
                  //                           : Colors.white));
                  //             })),
                  //       )
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Switches between (make a new complain) or (select the chosen complain)
                ElevatedButton(
                    onPressed: isExistingComplainSelected
                        ? onPickingExistingComplain
                        : onMakingNewComplain,
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 40))),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ))
                        : Text(isExistingComplainSelected
                            ? 'Select This Complain'
                            : 'Make A New Complain'))
              ],
            )
          ],
        ),
      )),
    );
  }
}
