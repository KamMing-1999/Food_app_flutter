import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/pages/account/account_page.dart';
import 'package:food_app_firebase/pages/address/add_address_page.dart';
import 'package:food_app_firebase/pages/auth/sign_up_page.dart';
import 'package:food_app_firebase/pages/cart/cart_history.dart';
import 'package:food_app_firebase/pages/home/main_food_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../utils/colors.dart';

// 277. Create a Home Page stateful class to create a homepage.
class HomePage extends StatefulWidget {
  // final String name, email, phone;
  // HomePage({Key? key, required this.name, required this.email, required this.phone}) : super(key: key);
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // 279. Create a list of pages for routing and use index to get the current page. Put it inside the Scaffold body.
  int _selectedIndex = 0;
  // late PersistentTabController _controller;

  late String name, email, phone;

  // 284. Use initState to initialize the variable before the class takes action.
  @override
  void initState() {
    super.initState();
    // name = widget.name;
    //_controller = PersistentTabController(initialIndex: 0);
  }

  List pages = [
    MainFoodPage(),
    Container(),
    CartHistory(),
    AccountPage(),
  ];

  // 283. Create a function to check which bottom nav button is tapped. setState will also change the UI.
  void onTapNav(int index) {
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      // 280. Create bottom Navigation Bar and create several items for routing.
      bottomNavigationBar: BottomNavigationBar(
        // 281. Create 4 Bottom Navigation Bar Items (Home, History, Cart and Me) and follow the settings.
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.amberAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
        ]
      ),
    );
  }

  // 286. List out the build screens.
  /*List<Widget> _buildScreens() {
    return [
      MainFoodPage(),
      Container(child: Center(child: Text("Next page"),),),
      Container(child: Center(child: Text("Next next page"),),),
      Container(child: Center(child: Text("Next next next page"),),),
    ];
  }

  // 287. List out the nav bar items.
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.archivebox_fill),
        title: ("Archive"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.cart_fill),
        title: ("Cart"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Me"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  // 285. Use Persistent Tab View to build the bottom navigation bar.
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }*/
}
