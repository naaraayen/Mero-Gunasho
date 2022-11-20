import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temporary_data.dart';
import '../screens/reg_complain_screen_2.dart';
import '../widgets/custom_text.dart';
import '../widgets/styled_title.dart';

// Page that loads up after clicking Floating Action Button
class RegisterComplainScreen1 extends StatefulWidget {
  static const routeName = '/RegisterComplainScreen1';
  const RegisterComplainScreen1({super.key});

  @override
  State<RegisterComplainScreen1> createState() =>
      _RegisterComplainScreen1State();
}

class _RegisterComplainScreen1State extends State<RegisterComplainScreen1> {
  var onSelectedWardNo;

  var onSelectedCategory;

  // static data
  // TODO: Fetch these data from admin panel

  List<String> wardList = ['1', '2', '3', '4'];

  List<String> catList = [
    'Roads and Transportation',
    'Drinking Water',
    'Health'
  ];

  Widget customDropDown(String? value, String hintText, List menuItems,
      Function(Object?)? onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.black26, style: BorderStyle.solid, width: 0.80),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            value: value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            hint: Text(hintText),
            items: menuItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tempData = Provider.of<TemporaryData>(context, listen: false);
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
                  // DropDown to show wards
                  const CustomText(
                    'In Which Ward Are You Facing The Problem?',
                  ),
                  customDropDown(onSelectedWardNo, 'Ward No', wardList,
                      (value) {
                    if (value != null) {
                      setState(() {
                        onSelectedWardNo = value;
                        tempData.setWardNo(onSelectedWardNo);
                      });
                    }
                  }),

                  // DropDown to show complain category
                  const CustomText(
                    'In Which Category Are You Facing The Problem?',
                  ),
                  customDropDown(onSelectedCategory, 'Category', catList,
                      (value) {
                    if (value != null) {
                      setState(() {
                        onSelectedCategory = value;
                        tempData.setCategory(onSelectedCategory);
                      });
                    }
                  }),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (onSelectedWardNo == null ||
                          onSelectedCategory == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Invalid Selection !'),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        Navigator.pushNamed(
                            context, RegisterComplainScreen2.routeName,
                            arguments: {
                              'wardNo': onSelectedWardNo,
                              'category': onSelectedCategory,
                            });
                      }
                    },
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 40))),
                    child: const Text('Next'))
              ],
            )
          ],
        ),
      )),
    );
  }
}
