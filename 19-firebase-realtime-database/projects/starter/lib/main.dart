import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/message_dao.dart';
import '../data/user_dao.dart';
import 'ui/login.dart';
import 'ui/message_list.dart';

// TODO: Ask Jim, page 631, are you seeing the slow on firebase too?
// Or are you using a workaround?
// It took quite awhile to build this small app.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDao>(
          lazy: false,
          create: (_) => UserDao(),
        ),
        Provider<MessageDao>(
          lazy: false,
          create: (_) => MessageDao(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RayChat',
        theme: ThemeData(primaryColor: const Color(0xFF3D814A)),
        home: Consumer<UserDao>(
          builder: (
            context,
            userDao,
            child,
          ) {
            if (userDao.isLoggedIn()) {
              return const MessageList();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
