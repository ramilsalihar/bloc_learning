import 'package:flutter/material.dart';
// import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;
import 'package:cubit/cubit.dart';

void main() {
  runApp(MaterialApp(
    title: 'Demo App',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    debugShowCheckedModeBanner: false,
    home: const MyHomePage(),
  ));
}

const names = [
  'Foo',
  'Nan',
  'Bar',
];

// Getting random index from 0 to length of list exludinglly
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

// Constructor of Cubit
class NamesCubit extends Cubit<String?> {
  // Cubit and Bloc requires initialState
  NamesCubit() : super(null); // No initial state by providing null

  // state had only getter
  void pickRandomName() => emit(
        // emit --> your way of producing new value
        names.getRandomElement(),
      );
}

// When you create Cubit make sure to dispose them

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    // cleaning up the cubit
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.asBroadcastStream(), // Stream will produce a value and go to builder
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () {
              cubit.pickRandomName();
            },
            child: const Text('Pick a random name'),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(children: [
                Text(snapshot.data ?? ''),
                button
              ],);
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
