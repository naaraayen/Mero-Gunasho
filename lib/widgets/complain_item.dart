import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/complain.dart';

class ComplainItem extends StatefulWidget {
  final String complainId;
  final Color defaultColor;
  final bool ifUserComplains;
  const ComplainItem(this.complainId, this.defaultColor, this.ifUserComplains, {super.key});

  @override
  State<ComplainItem> createState() => _ComplainItemState();
}

class _ComplainItemState extends State<ComplainItem> {
  Color color = Colors.white;
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final complainData = Provider.of<Complain>(context, listen: false);
    final complainItem = complainData.findComplainById(widget.ifUserComplains,widget.complainId);
    final timeWaited = DateTime.now().difference(complainItem.dateTime).inDays;
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.defaultColor,
            border: Border.all(
              color: Colors.black26,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  complainItem.title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const Spacer(),
                InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Icon(isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)),
                //IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Status : '),
                Chip(label: Text(complainItem.status))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  const TextSpan(text: 'Time Waited : '),
                  TextSpan(text: '${timeWaited.toString()} days'),
                ])),
                const Spacer(),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: 'Ward No. : '),
                  TextSpan(text: complainItem.wardNo.toString()),
                ]))
              ],
            ),
            Text.rich(TextSpan(children: [
              const TextSpan(text: 'Category : '),
              TextSpan(text: complainItem.category),
            ])),
            Text.rich(TextSpan(children: [
              const TextSpan(text: 'Assigned To : '),
              TextSpan(text: complainItem.assignedTo),
            ])),
            if (isExpanded)
              Text.rich(TextSpan(children: [
                const TextSpan(text: 'Description : '),
                TextSpan(text: complainItem.description),
              ])),
          ],
        ));
  }
}
