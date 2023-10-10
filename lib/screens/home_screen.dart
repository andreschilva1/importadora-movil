import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/screens/edit_profile.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_note_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfile()),
              );
            },
          ),
        ],
        centerTitle: true,
        title: const Text('Perfil'),
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: authService.readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex:3,
                        child:Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 28, 15, 66),Color.fromARGB(255, 74, 69, 88)],
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 70),
                              const CircleAvatar(
                                radius: 70.0,
                                backgroundImage: NetworkImage('https://gogeticon.net/files/1925428/fa0cbc2764f70113bf2fad3905933545.png'),
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(height: 10.0,),
                              Text(snapshot.data!.name,
                              style: const TextStyle(
                                color:Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w800,
                              )),
                          ]
                          ),
                        ),
                      ),
                      Expanded(
                        flex:3,
                        child: Container(
                          color: Colors.grey[200],
                          child: Center(
                              child:Card(
                                  margin: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .85,
                                  height: MediaQuery.of(context).size.height * .3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Información",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w800,
                                        ),),
                                        Divider(color: Colors.grey[300],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              color: Colors.blueAccent[400],
                                              size: 35,
                                            ),
                                            const SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Email",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),),
                                                Text(snapshot.data!.email,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        const SizedBox(height: 20.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.phone_android_outlined,
                                              color: Colors.yellowAccent[400],
                                              size: 35,
                                            ),
                                            const SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Celular",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),),
                                                Text(snapshot.data!.celular!,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        const SizedBox(height: 20.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.manage_accounts_outlined,
                                              color: Colors.pinkAccent[400],
                                              size: 35,
                                            ),
                                            const SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Rol",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),),
                                                Text(snapshot.data!.rol,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        const SizedBox(height: 20.0,)
                                      ],
                                    ),
                                  )
                                )
                              )
                            ),
                          ),
                      ),
                    ],
                  ),
                  Positioned(
                    top:MediaQuery.of(context).size.height * 0.4,
                    left: 20.0,
                    right: 20.0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('Battles',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.0
                                ),),
                                const SizedBox(height: 5.0,),
                                const Text("1",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),)
                              ],
                            ),
                            Column(
                            children: [
                              Text('Birthday',
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14.0
                                ),),
                              const SizedBox(height: 5.0,),
                              const Text('April 7th',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),)
                            ]),
                            Column(
                              children: [
                                Text('Age',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.0
                                  ),),
                                const SizedBox(height: 5.0,),
                                const Text('19 yrs',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),)
                              ],
                            ),
                          ],
                        ),
                      )
                    )
                )
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
