import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/screens/edit_profile_screen.dart';
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
      body: SingleChildScrollView(
        child: FutureBuilder<User>(
          future: authService.readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data!;
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 28, 15, 66),
                          Color.fromARGB(255, 74, 69, 88)
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 70.0),
                        const CircleAvatar(
                          radius: 70.0,
                          backgroundImage: AssetImage("Assets/user.png"),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: Center(
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * .85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Información",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Divider(color: Colors.grey[300]),
                              _buildInfoRow(
                                icon: Icons.email_outlined,
                                label: "Email",
                                value: user.email,
                              ),
                              Divider(color: Colors.grey[300]),
                              _buildInfoRow(
                                icon: Icons.phone_android_outlined,
                                label: "Celular",
                                value: user.celular!,
                                colorIcon: Colors.yellowAccent[400],
                              ),
                              Divider(color: Colors.grey[300]),
                              _buildInfoRow(
                                icon: Icons.manage_accounts_outlined,
                                label: "Rol",
                                value: user.rol,
                                colorIcon: Colors.pinkAccent[400],
                              ),

                               Divider(color: Colors.grey[300]),
                              (user.rol == 'Cliente') 
                              ? _buildInfoRow(
                                icon: Icons.web_sharp,
                                label: "Casillero",
                                value: user.casillero ?? '',
                                colorIcon: Colors.brown[500],
                              )
                              : Container(),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? colorIcon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon,
            color: (colorIcon == null) ? Colors.blueAccent[400] : colorIcon,
            size: 35),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              width: 200, // Define un ancho máximo para el valor.
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                maxLines:
                    2, // Define el número máximo de líneas antes de truncar.
                overflow: TextOverflow
                    .ellipsis, // Define cómo se maneja el desbordamiento.
              ),
            ),
          ],
        ),
      ],
    );
  }
}
