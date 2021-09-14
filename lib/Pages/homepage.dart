import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_blog_app/Pages/loginPage.dart';
import 'package:recipe_blog_app/Profile/ProfileScreen.dart';
import 'package:recipe_blog_app/screens/Blogs/addBlog.dart';
import 'package:recipe_blog_app/screens/homeScreen.dart';

import '../apiHandler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Aunty Kat Recipe Blog", "Profile Page"];
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  String username = "";
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if (response["status"] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      setState(() {
        profilePhoto = Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: Column(
      //           children: <Widget>[
      //             profilePhoto,
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Text("@$username"),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         title: Text("All Post"),
      //         trailing: Icon(Icons.launch),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: Text("New Story"),
      //         trailing: Icon(Icons.add),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: Text("Settings"),
      //         trailing: Icon(Icons.settings),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: Text("Feedback"),
      //         trailing: Icon(Icons.feedback),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: Text("Logout"),
      //         trailing: Icon(Icons.power_settings_new),
      //         onTap: logout,
      //       ),
      //     ],
      //   ),
      // ),
      // appBar: AppBar(
      //   backgroundColor: Color(0xffe46b10),
      //   title: Text(titleString[currentState]),
      //   centerTitle: true,
      //   actions: <Widget>[
      //     IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
      //   ],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffe46b10),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color:  Color(0xffe46b10),
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentState == 0 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false);
  }
  
}
