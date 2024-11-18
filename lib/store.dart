import 'dart:collection';

import 'package:flutter/material.dart';

class ImageModel {
  const ImageModel({
    required this.title,
    required this.subTitle,
    required this.imageUrl,
  });

  final String title;
  final String subTitle;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const defaultImages = [
  ImageModel(
    title: 'Mount Rushmore',
    subTitle: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  ImageModel(
    title: 'Gardens By The Bay',
    subTitle: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  ImageModel(
    title: 'Machu Picchu',
    subTitle: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  ImageModel(
    title: 'Vitznau',
    subTitle: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  ImageModel(
    title: 'Bali',
    subTitle: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  ImageModel(
    title: 'Mexico City',
    subTitle: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  ImageModel(
    title: 'Cairo',
    subTitle: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];

class Store extends ChangeNotifier {
  final List<ImageModel> _images = [...defaultImages];

  UnmodifiableListView<ImageModel> get images => UnmodifiableListView(_images);

  void add(ImageModel image) {
    _images.add(image);
    notifyListeners();
  }

  void remove(ImageModel image) {
    _images.remove(image);
    notifyListeners();
  }

  void removeAll() {
    _images.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void reset() {
    _images
      ..clear()
      ..addAll(defaultImages);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final image = _images.removeAt(oldIndex);
    _images.insert(newIndex, image);
  }
}
