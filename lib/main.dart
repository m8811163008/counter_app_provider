import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    //Provide the model to all widgets within the app
    //We're using ChangeNotifierProvider because that's
    // a simple way to rebuild widgets when a model changes.
    //we could also just use Provider, but then we have to listen to Counter ourselves.
    //all available provider for later...
    ChangeNotifierProvider(
      //Initialize the model in the builder.That way,
      //Provider can own counter's lifecycle, make sure
      //to call dispose when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

///simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`.
/// [Counter] does _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;
  void increment() {
    value++;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter demo home page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            //Consumer looks for an ancestor Provider widget
            //and retrieves its model (Countee, in this case).
            //Then it uses that model to build widgets, and will trigger rebuilds if the model is updated
            Consumer<Counter>(
                builder: (context, counter, child) => Text(
                      '${counter.value}',
                      style: Theme.of(context).textTheme.headline4,
                    ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //you can access your providers anywhere you have access to the context. One way is to use Provider.of<Counter>(context).
          //
          //The Provider package also defines extension methods in context itself. you can call context.watch<Counter>() in a build method
          //of any widget to access the current state of Counter, and to ask Flutter to rebuild your widget anytime Counter changes.
          //You can't use context.watch() outside build methods, because that often leads to subtle bugs. Instead, you should use context.read<Counter>(), which gets the current state but doesn't ask flutter for future rebuilds.
          //
          //Since we're in a callback that will be called whenever the user taps the FAB, we are not in the build method here.
          //We should use context.read()
          var counter = context.read<Counter>();
          counter.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
