import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

late User loggedinUser;

enum Category {
  food,
  medicine,
  transport,
  work,
  equipment,
  money,
  other
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void _openMenu() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(title: const Text('Menu')),
              body: const Center(),
              floatingActionButton: Row(
                children:[
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      heroTag: null, child: const Icon(Icons.home)),
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/creates_task', (route) => false);
                      },heroTag: null ,child: const Icon(Icons.add)) ],
              )

          );
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список потреб'),
        actions: [
          IconButton(
              onPressed: (){
                _openMenu();
              },
              icon: Icon(Icons.menu)
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) {
            return const Text('Покищо немає потреб');
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text("${snapshot.data!.docs[index].get('title')} "),
                      subtitle: Text("User : ${snapshot.data!.docs[index].get('user')}"),
                      trailing: IconButton(
                        icon: const Icon(
                            Icons.more_vert,
                            color: Colors.blue),
                        onPressed: () {
                          setState(() {

                          });
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {

                    });
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: (const Icon(Icons.add, size: 40)),
        onPressed: () {
          Navigator.pushNamed(context, 'create_task');
        },
      ),
    );
  }
}
