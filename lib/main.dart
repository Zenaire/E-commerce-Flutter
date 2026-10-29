import 'package:e_commerce_app/pages/detail_chat.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/pages/home_page.dart';
import 'package:e_commerce_app/pages/login_page.dart';
import 'package:e_commerce_app/pages/sign_up_page.dart';
import 'package:e_commerce_app/pages/account_page.dart';
import 'package:e_commerce_app/pages/change_pass_page.dart';
import 'package:e_commerce_app/pages/list_chat.dart';

// import 'package:e_commerce_app/pages/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Color(0xFF2563EB))),
      home: const HomePage(),
      routes: {
        '/Home_page': (context) => const HomePage(),
        '/login_page': (context) => const LoginPage(),
        '/sign_up_page': (context) => const SignUpPage(),
        '/account_page': (context) => const AccountPage(),
        '/change_pass_page': (context) => const ChangePassPage(),
        '/cart_page': (context) => const HomePage(),
        '/listChat_page': (context) => const ListChatPage(),
        '/detailChat_page': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          final contactName =
              arguments is Map && arguments['contactName'] is String
              ? arguments['contactName'] as String
              : 'Anonim';
          final chatId = arguments is Map && arguments['chatId'] is String
              ? arguments['chatId'] as String
              : null;
          final storeCategory =
              arguments is Map && arguments['storeCategory'] is String
              ? arguments['storeCategory'] as String
              : null;
          final isOnline = arguments is Map && arguments['isOnline'] is bool
              ? arguments['isOnline'] as bool
              : null;
          final avatarUrl = arguments is Map && arguments['avatarUrl'] is String
              ? arguments['avatarUrl'] as String
              : null;
          return ChatScreen(
            contactName: contactName,
            chatId: chatId,
            storeCategory: storeCategory,
            isOnline: isOnline,
            avatarUrl: avatarUrl,
          );
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [const Text('You have pushed the button this many times:')],
        ),
      ),
    );
  }
}
