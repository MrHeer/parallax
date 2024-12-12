import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parallax/import_image_dialog.dart';
import 'package:parallax/store.dart';
import 'package:parallax/parallax_image.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Store(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Parallax'),
          forceMaterialTransparency: true,
        ),
        body: const ParallaxListView(),
        floatingActionButton: const ImportImageButton(),
      ),
    );
  }
}

class ImportImageButton extends StatelessWidget {
  const ImportImageButton({
    super.key,
  });

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => ImportImageDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: context.read<Store>().reset,
      child: FloatingActionButton(
        onPressed: () => _dialogBuilder(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ParallaxListView extends StatelessWidget {
  const ParallaxListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double scale = lerpDouble(1, 1.05, animValue)!;
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: child,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontal = 24;
        if (constraints.maxWidth > 1536) {
          horizontal = 480;
        } else if (constraints.maxWidth > 1024) {
          horizontal = 320;
        } else if (constraints.maxWidth > 640) {
          horizontal = 160;
        }
        return Consumer<Store>(
          builder: (context, store, child) {
            return ReorderableListView.builder(
              onReorder: store.reorder,
              buildDefaultDragHandles: false,
              proxyDecorator: proxyDecorator,
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              itemCount: store.images.length,
              itemBuilder: (context, index) {
                final image = store.images[index];
                return Dismissible(
                  key: Key(image.imageUrl),
                  onDismissed: (_) => store.remove(image),
                  child: ReorderableDelayedDragStartListener(
                    index: index,
                    child: ParallaxImage(
                      imageUrl: image.imageUrl,
                      title: image.title,
                      subTitle: image.subTitle,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
