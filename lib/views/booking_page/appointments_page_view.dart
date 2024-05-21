import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppointmentsPageView extends StatefulWidget {
  const AppointmentsPageView({super.key});

  @override
  State<AppointmentsPageView> createState() => _AppointmentsPageViewState();
}

class _AppointmentsPageViewState extends State<AppointmentsPageView> {
  String? urlPhoto;
  List<String> listFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pág agendamentos"),
      ),
      body: Column(
        children: [
          (urlPhoto != null)
              ? Container()
              : const CircleAvatar(
                  radius: 64,
                  child: Icon(Icons.person),
                ),
        ],
      ),
    );
  }

  uploadImage() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
      source: ImageSource.gallery,
      maxHeight: 2000,
      maxWidth: 2000,
      imageQuality: 50,
    )
        .then((XFile? image) {
      if (image != null) {
      } else {}
    });
  }
}
