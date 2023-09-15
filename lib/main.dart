import 'dart:math';

import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var colorOne = Colors.yellow;
  var colorTwo = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: AvailableColorsWidget(
        colorOne: colorOne,
        colorTwo: colorTwo,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      colorOne = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change colorOne'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      colorTwo = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change colorTwo'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor colorOne;
  final MaterialColor colorTwo;

  const AvailableColorsWidget({
    Key? key,
    required this.colorOne,
    required this.colorTwo,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

// this function is only used by the descendants
  static AvailableColorsWidget of(
    BuildContext context,
    AvailableColors aspect,
  ) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspect,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    return colorOne != oldWidget.colorOne || colorTwo != oldWidget.colorTwo;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    if (dependencies.contains(AvailableColors.one) &&
        colorOne != oldWidget.colorOne) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        colorTwo != oldWidget.colorTwo) {
      return true;
    }

    return false;
  }
}

class ColorWidget extends StatelessWidget {
  const ColorWidget({
    super.key,
    required this.color,
  });

  final AvailableColors color;

  @override
  Widget build(BuildContext context) {
    final provider = AvailableColorsWidget.of(
      context,
      color,
    );

    return Container(
      height: 100,
      color:
          color == AvailableColors.one ? provider.colorOne : provider.colorTwo,
    );
  }
}

// colors array
final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple,
];

// randomly grab color
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        Random().nextInt(length),
      );
}
