import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'info_dev.dart';
import 'editing_profile.dart';
import 'auth_provider.dart';
import 'main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: authProvider.fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/forest.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Профиль',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        color: Colors.black,
                        onPressed: () {
                          authProvider.logout();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          MyHomePage.homePageKey.currentState?.changeTab(2);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: authProvider.imageUrl != null &&
                                  authProvider.imageUrl!.isNotEmpty
                              ? NetworkImage(
                                  'http://10.0.2.2:5000${authProvider.imageUrl}')
                              : const AssetImage('assets/images/user_photo.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          authProvider.fullName,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          authProvider.countryName,
                          style: const TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditingProfileScreen()),
                            ).then((value) {
                              if (value == true) {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .fetchUserData();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: const Size(300, 40),
                          ),
                          child: const Text(
                            'Редактировать профиль',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InfoScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: const Size(270, 40),
                          ),
                          child: const Text(
                            'О приложении',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
