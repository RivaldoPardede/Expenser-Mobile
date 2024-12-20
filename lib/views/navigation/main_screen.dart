import 'package:final_project/views/home/home_page.dart';
import 'package:final_project/views/record/record_page.dart';
import 'package:final_project/views/settings/settings.dart';
import 'package:final_project/views/statistic/statistic_page.dart';
import 'package:final_project/views/transaction/transaction_page.dart';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'nav_model.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final statisticNavKey = GlobalKey<NavigatorState>();
  final transactionHistoryNavKey = GlobalKey<NavigatorState>();
  final settingsNavKey = GlobalKey<NavigatorState>();

  int selectedTab = 0;

  late final List<NavModel> items = [
    NavModel(page: const HomePage(), navKey: homeNavKey),
    NavModel(page: const StatisticPage(), navKey: statisticNavKey),
    NavModel(page: const RecordPage(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: const TransactionPage(), navKey: transactionHistoryNavKey),
    NavModel(page: const Settings(), navKey: settingsNavKey),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: selectedTab,
          children: items.map((e) {
            return Navigator(
              key: e.navKey,
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [
                  MaterialPageRoute(builder: (context) => e.page),
                ];
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.95,
            ),
            builder: (context) => const RecordPage(),
          ),
          backgroundColor: const Color(0xFF5B9EE1),
          elevation: 5,
          shape: const CircleBorder(),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.add, size: 35, color: Colors.white),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index != selectedTab) {
              setState(() => selectedTab = index);
            } else {
              items[index].navKey.currentState?.popUntil((route) => route.isFirst);
            }
          },
        ),
      ),
    );
  }
}
