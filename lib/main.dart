
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// 1. SPLASH SCREEN WITH ANIMATION
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library,
                  size: 90,
                  color: Colors.white,
                ),
                SizedBox(height: 15),
                Text(
                  'My Gallery App',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 2. COMMON DRAWER
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void openPage(BuildContext context, String page) {
    Navigator.pop(context);

    Widget screen;

    if (page == 'Home') {
      screen = const HomePage();
    } else if (page == 'List') {
      screen = const ListScreen();
    } else {
      screen = const AboutScreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            accountName: Text('Student'),
            accountEmail: Text('Hafiz Hamza@example.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 35),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => openPage(context, 'Home'),
          ),

          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('List Screen'),
            onTap: () => openPage(context, 'List'),
          ),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Screen'),
            onTap: () => openPage(context, 'About'),
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 15,
            endIndent: 15,
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const SimplePage(title: 'Settings'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 3. HOME SCREEN / GALLERY
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<String> images = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        backgroundColor: Colors.green,
      ),

      drawer: const AppDrawer(),

      body: Column(
        children: [
          Card(
            elevation: 4,
            color: Colors.white,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: const Icon(
                Icons.add_alarm,
                color: Colors.green,
                size: 30,
              ),
              title: const Text(
                'Alarm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: const Text("Alarm at 10 o'clock"),
              trailing: const Icon(
                Icons.access_alarm,
                color: Colors.green,
                size: 28,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SimplePage(title: 'Alarm'),
                  ),
                );
              },
            ),
          ),

          const Divider(
            color: Colors.green,
            thickness: 2,
            indent: 15,
            endIndent: 15,
          ),

          Expanded(
            child: selectedIndex == 0
                ? PicturesPage(images: images)
                : AlbumPage(images: images),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Pictures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Album',
          ),
        ],
      ),
    );
  }
}

// 4. PICTURES PAGE
class PicturesPage extends StatelessWidget {
  final List<String> images;

  const PicturesPage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: images.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  image: images[index],
                  heroTag: 'picture-$index',
                ),
              ),
            );
          },
          child: Hero(
            tag: 'picture-$index',
            child: Image.asset(
              images[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

// 5. ALBUM PAGE
class AlbumPage extends StatelessWidget {
  final List<String> images;

  const AlbumPage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AlbumDetailPage(images: images),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Image.asset(
                  images[0],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const ListTile(
                  leading: Icon(
                    Icons.folder,
                    color: Colors.green,
                  ),
                  title: Text('My Memories'),
                  subtitle: Text('3 Pictures'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 6. ALBUM DETAIL PAGE
class AlbumDetailPage extends StatelessWidget {
  final List<String> images;

  const AlbumDetailPage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memories'),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: images.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    image: images[index],
                    heroTag: 'album-picture-$index',
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'album-picture-$index',
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

// 7. IMAGE DETAIL PAGE
class DetailPage extends StatelessWidget {
  final String image;
  final String heroTag;

  const DetailPage({
    super.key,
    required this.image,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Detail'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: Image.asset(
            image,
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// 8. LIST SCREEN WITH 10 ITEMS
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  final List<String> items = const [
    'Islamabad',
    'Lahore',
    'Karachi',
    'Peshawar',
    'Quetta',
    'Multan',
    'Faisalabad',
    'Rawalpindi',
    'Abbottabad',
    'Murree',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Screen'),
        backgroundColor: Colors.green,
      ),

      drawer: const AppDrawer(),

      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.location_city,
                color: Colors.green,
              ),
              title: Text(items[index]),
              subtitle: Text('City ${index + 1}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SimplePage(title: items[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 9. ABOUT SCREEN WITH 6 GRID ITEMS
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final List<Map<String, dynamic>> items = const [
    {'name': 'Gallery', 'icon': Icons.photo},
    {'name': 'Album', 'icon': Icons.folder},
    {'name': 'Alarm', 'icon': Icons.alarm},
    {'name': 'Camera', 'icon': Icons.camera_alt},
    {'name': 'Settings', 'icon': Icons.settings},
    {'name': 'Profile', 'icon': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Screen'),
        backgroundColor: Colors.green,
      ),

      drawer: const AppDrawer(),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  items[index]['icon'] as IconData,
                  size: 45,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                Text(
                  items[index]['name'] as String,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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

// 10. SIMPLE PAGE
class SimplePage extends StatelessWidget {
  final String title;

  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
