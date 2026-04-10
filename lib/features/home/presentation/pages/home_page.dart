import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/presentation/pages/request_type.dart'
    show RequestType;
import 'package:cridr/features/provider/presentation/pages/map_page.dart';
import 'package:cridr/features/provider/presentation/pages/pending_request.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? role; // nullable until loaded
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final storedRole = await LocalStorage().readData("role");
    setState(() {
      role = storedRole; // fallback to true if null
      print("Role: $role");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Pages depend on role
    final List<Widget> _pages = [
      role == "User" ? RequestType() : MapPage(),
      Container(),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "CRidr",
          style: TextStyle(
            color: ZColors.primaryColor,
            fontSize: 32,
            fontFamily: "KyivTypeSans",
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
      ),
    );
  }
}
