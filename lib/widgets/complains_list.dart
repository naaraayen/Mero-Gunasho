import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text.dart';
import '../providers/complain.dart';
import '../widgets/complain_item.dart' as ci;

class ComplainsList extends StatelessWidget {
  const ComplainsList({super.key});
  @override
  Widget build(BuildContext context) {
    final complainData = Provider.of<Complain>(context, listen: false);
    return complainData.items.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 6,
                  child: Image.asset(
                    'assets/logos/mero_gunasho_empty_complain.png',
                    fit: BoxFit.cover,
                  )),
              const Expanded(
                  flex: 3,
                  child: CustomText(
                      'No Complains Registered By You Yet. Click On ( + ) To Add Your Complain If You Have Any.'))
            ],
          )
        : ListView.builder(
            itemCount: complainData.items.length,
            itemBuilder: (context, index) {
              return ci.ComplainItem(
                  complainData.items[index].id, Colors.white, true);
            },
          );
  }
}
