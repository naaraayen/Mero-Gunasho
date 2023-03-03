import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/complain.dart';
import '../providers/temporary_data.dart';
import '../widgets/complain_item.dart' as ci;

class SelectableComplainList extends StatefulWidget {
  const SelectableComplainList({super.key});

  @override
  State<SelectableComplainList> createState() => _SelectableComplainListState();
}

class _SelectableComplainListState extends State<SelectableComplainList> {
  var isLoading = false;
  int? selectedIndex;
  int? prevValue;
  bool isSelected = false;
  var selectedComplain = '';
  void toggleSelection(int index, String complainId) {
    if (prevValue == index) {
      setState(() {
        isSelected = !isSelected;
        prevValue = null;
      });
      return;
    }
    setState(() {
      selectedIndex = index;
      isSelected = true;
    });
    selectedComplain = complainId;
    prevValue = selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final tempData = Provider.of<TemporaryData>(context, listen: false);
    final getWardList = Provider.of<Complain>(context, listen: false)
        .filterComplain(int.parse(tempData.wardNo!), tempData.category!);

    return getWardList.isEmpty
        ? const Text('Unable To Fetch')
        : ListView.builder(
            itemCount: getWardList.length,
            itemBuilder: ((ctx, index) {
              return InkWell(
                  onTap: () {
                    //isSelected = false;
                    toggleSelection(index, getWardList[index].id);
                  },
                  child: ci.ComplainItem(
                      getWardList[index].id,
                      selectedIndex == index
                          ? (isSelected ? Colors.grey : Colors.white)
                          : Colors.white, false));
            }));
  }
}
