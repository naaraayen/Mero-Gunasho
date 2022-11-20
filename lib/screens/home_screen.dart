import 'package:flutter/material.dart';
import 'package:mero_gunasho/screens/reg_complain_screen_1.dart';
import 'package:mero_gunasho/widgets/complains_list.dart';
import '../widgets/stat_item.dart';
import 'package:provider/provider.dart';
import '../providers/complain.dart';
//import '../widgets/complain_item.dart' as ci;

class Home extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future complainFuture;

  @override
  void initState() {
    // Passing the future reference
    complainFuture =
        Provider.of<Complain>(context, listen: false).fetchComplains(true);
    super.initState();
  }

  Widget buildTitle(String getSring) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        getSring,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0XFF0071BC),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RegisterComplainScreen1.routeName);
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // GridView to show complain stats
                      buildTitle('My Complain Stats'),
                      Expanded(
                        flex: 4,
                        child: GridView.builder(
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.5,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (ctx, index) => Consumer<Complain>(
                                  builder: (ctx, comData, _) => StatItem(
                                      comData.complainStat.values
                                          .toList()[index]['data'],
                                      comData.complainStat.keys.toList()[index],
                                      comData.complainStat.values
                                          .toList()[index]['color']),
                                )),
                      ),

                      // ListView to show reported complains
                      buildTitle('My Reported Complains'),
                      Expanded(
                        flex: 12,
                        child: FutureBuilder(
                            future: complainFuture,
                            builder: ((ctx, dataSnapshot) {
                              if (dataSnapshot.connectionState ==
                                  ConnectionState.done) {
                                if (dataSnapshot.hasError) {
                                  return const Center(
                                    child:
                                        Text('Unable To Fetch Your Complains'),
                                  );
                                }
                                return const ComplainsList(); // Widget to show listview
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            })),
                      ),
                    ]))));
  }
}
