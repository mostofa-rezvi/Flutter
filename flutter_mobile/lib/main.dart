// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.greenAccent,
      ),
      darkTheme: ThemeData(primarySwatch: Colors.blue),
      color: Colors.amberAccent,
      debugShowCheckedModeBanner: false,
      home: HomeActivity(),
    );
  }
}

class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

  MySnackBar(message, context) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  MyAlartDialog(context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Expanded(
              child: AlertDialog(
                title: Text("Alert!"),
                content: Text("Do you want to accept this?"),
                actions: [
                  TextButton(
                      onPressed: (){
                        MyAlartDialog("Deleted full item");
                        Navigator.of(context).pop();
                      },
                      child: Text("Accept")
                  ),
                  TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Deny"))
                ],
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.all(24),
      backgroundColor: Colors.red,
      foregroundColor: Colors.lime,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.greenAccent,

      appBar: AppBar(
        title: Text("Inventory App"),
        titleSpacing: 10,
        centerTitle: true,
        toolbarHeight: 60,
        toolbarOpacity: 1,
        elevation: 30,
        backgroundColor: Colors.lime,
        actions: [
          IconButton(
            onPressed: () {
              MySnackBar("I am Comments", context);
            },
            icon: Icon(Icons.comment),
          ),
        ],
      ),

      body: Center(
        child: ElevatedButton(
          child: Text("Click"),
          onPressed: (){
            MyAlartDialog(context);
          },
        ),
      ),

      // body: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     TextButton(
      //       onPressed: () {
      //         // MySnackBar("Text Button", context);
      //         buttonStyle;
      //       },
      //       child: Text("Text Button"),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         buttonStyle;
      //       },
      //       child: Text("Elevated Button"),
      //     ),
      //     OutlinedButton(
      //       onPressed: () {
      //         // MySnackBar("Out Lined Button", context);
      //         buttonStyle;
      //       },
      //       child: Text("Outlined Button"),
      //     ),
      //   ],
      // ),

      // body: Center(
      //   child:
      //   // Text("hello"),
      // Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000")
      // ),

      // body: Container(
      //   height: 250,
      //   width: 250,
      //   alignment: Alignment.topCenter,
      //   margin: EdgeInsets.all(50),
      //   // padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
      //   decoration: BoxDecoration(
      //     color: Colors.blueGrey,
      //     border: Border.all(color: Colors.lightGreen, width: 5)
      //   ),
      //   child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),
      // ),

      // body: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     Container(height: 100, width: 80, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //     Container(height: 100, width: 80, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //     Container(height: 100, width: 80, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //     Container(height: 100, width: 80, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //
      //   ],
      // ),

      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Container(height: 100, width: 100, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //     Container(height: 100, width: 100, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //     Container(height: 100, width: 100, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //     Container(height: 100, width: 100, child: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),),
      //   ],
      // ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                accountName: Text("Rezvi", style: TextStyle(color: Colors.red)),
                accountEmail: Text(
                  "rezvi@gmail.com",
                  style: TextStyle(color: Colors.red),
                ),
                currentAccountPicture: Image.network(
                  "https://img.pikbest.com/origin/10/41/85/35HpIkbEsTU62.png!sw800",
                ),
                //currentAccountPicture: Image.network("https://images.unsplash.com/photo-1569327445198-f453837c86bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc3Vuc2V0fGVufDB8fDB8fHww&fm=jpg&q=60&w=3000"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                MySnackBar("This is Home", context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text("Contact"),
              onTap: () {
                MySnackBar("This is Contact", context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                MySnackBar("This is Profile", context);
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              onTap: () {
                MySnackBar("This is Email", context);
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Phone"),
              onTap: () {
                MySnackBar("This is Phone", context);
              },
            ),
          ],
        ),
      ),

      // endDrawer: (), // same as drawer, its open on the right side only
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            MySnackBar("This is Home Button Tab", context);
          }
          if (index == 1) {
            MySnackBar("This is Contact Button Tab", context);
          }
          if (index == 2) {
            MySnackBar("This is Profile Button Tab", context);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.green,
        onPressed: () {
          MySnackBar("I am Floating Action Button", context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
