import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'change_pass.dart';

void main() {
  runApp(const SecurityPass());
}

class SecurityPass extends StatelessWidget {
  const SecurityPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SecurityPasswordScreen(),
    );
  }
}

class SecurityPasswordScreen extends StatefulWidget {
  const SecurityPasswordScreen({Key? key}) : super(key: key);

  @override
  _SecurityPasswordScreenState createState() => _SecurityPasswordScreenState();
}

class _SecurityPasswordScreenState extends State<SecurityPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Security & Password",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'image/LeftArrow.svg',
            placeholderBuilder: (context) => const Icon(Icons.arrow_back),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: SvgPicture.asset(
                  'image/key.svg',
                  placeholderBuilder: (context) => const Icon(Icons.vpn_key),
                ),
                title: const Text("Change Password"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigasi ke halaman Change Pass
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePass()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
