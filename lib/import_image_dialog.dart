import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'store.dart';

class ImportImageDialog extends StatelessWidget {
  ImportImageDialog({
    super.key,
  });

  final formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Form(
        key: formKey,
        child: AlertDialog(
          title: const Text('Import a Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: urlController,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text('Image URL')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text('Title')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: subTitleController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text('Subtitle')),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Import'),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (formKey.currentState!.validate()) {
                  final image = ImageModel(
                    title: titleController.text,
                    subTitle: subTitleController.text,
                    imageUrl: urlController.text,
                  );
                  context.read<Store>().add(image);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
