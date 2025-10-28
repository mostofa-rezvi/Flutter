import 'package:flutter/material.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(primarySwatch: Colors.red),
      // darkTheme: ThemeData(primarySwatch: Colors.amber),
      color: Colors.blueGrey,
      debugShowCheckedModeBanner: false,
      home: HomeTwoActivity(),
    );
  }
}

class HomeTwoActivity extends StatelessWidget {
  const HomeTwoActivity({super.key});

  mySnackBar(message, context) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App 01"),
        titleSpacing: 15,
        centerTitle: false,
        toolbarOpacity: 0.8,
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: Colors.green,

        actions: [
          IconButton(
            onPressed: () {
              mySnackBar("Comments", context);
            },
            icon: Icon(Icons.comment_bank_outlined),
          ),
          IconButton(
            onPressed: () {
              mySnackBar("Settings", context);
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              mySnackBar("Search", context);
            },
            icon: Icon(Icons.search_outlined),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.green,
        onPressed: () {
          mySnackBar("Floating Action Bar", context);
        },
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "SETTINGS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "PROFILE",
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            mySnackBar("Home", context);
          } else if (index == 1) {
            mySnackBar("Settings", context);
          } else if (index == 2) {
            mySnackBar("Profile", context);
          }
        },
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                accountName: Text("First Application", style: TextStyle(color: Colors.black),),
                accountEmail: Text("application@gmail.com", style: TextStyle(color: Colors.black),),
                // currentAccountPicture: Image.asset("assets/profile_image_01.jpg"),
                currentAccountPicture: Image.asset("assets/images/profile_image_01.jpg"),

              ),
            ),
            ListTile(
                leading: Icon(Icons.home_filled),
                title: Text("Home"),
              onTap: (){mySnackBar("Home", context);},
            ),
            ListTile(
              leading: Icon(Icons.contact_mail_outlined),
              title: Text("Contact"),
              onTap: (){mySnackBar("Contact", context);},
            ),
            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text("Profile"),
              onTap: (){mySnackBar("Profile", context);},
            ),
            ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text("Email"),
                onTap: (){mySnackBar("Email", context);},
            ),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              onTap: (){mySnackBar("Settings", context);},
            ),
          ],
        ),
      ),
    );
  }
}

class HomeOneActivity extends StatelessWidget {
  const HomeOneActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Name")),
      body: Text("Hello world..."),
      drawer: Text("Bye Bye"),
      endDrawer: Text("Bye Bye"),
      bottomNavigationBar: Text("Bottom Navigation Bar"),
      floatingActionButton: Text("Floating"),
    );
  }
}
