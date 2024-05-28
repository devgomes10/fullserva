import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/views/components/show_confirmation_password.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/authentication/auth_service.dart';
import '../../data/storage/storage_service.dart';
import 'account/account_view.dart';
import 'business/business_form_view.dart';
import 'opening_hours/opening_hours_view.dart';

class MoreView extends StatefulWidget {
  final User user;

  const MoreView({super.key, required this.user});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  String? urlPhoto;
  final StorageService _storageService = StorageService();

  uploadImage() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
      source: ImageSource.gallery,
      maxHeight: 2000,
      maxWidth: 2000,
      imageQuality: 50,
    )
        .then(
      (XFile? image) {
        if (image != null) {
          _storageService
              .upload(
            file: File(image.path),
            fileName: "user_photo",
          )
              .then((String urlDownload) {
            setState(() {
              urlPhoto = urlDownload;
            });
          });
        } else {}
      },
    );
  }

  reload() {
    _storageService
        .getDownloadUrlByFileName(fileName: "user_photo")
        .then((urlDownload) {
      setState(() {
        urlPhoto = urlDownload;
      });
    });
  }

  @override
  void initState() {
    reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MAIS OPÇÕES"),
        ),
        body: Column(
          children: [
            Text(widget.user.email!),
            Text((widget.user.displayName != null)
                ? widget.user.displayName!
                : ""),
            (urlPhoto != null)
                ? InkWell(
                    onTap: () {
                      uploadImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: InkWell(
                        onTap: () {
                          uploadImage();
                        },
                        child: Image.network(
                          urlPhoto!,
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const CircleAvatar(
                    radius: 64,
                    child: Icon(Icons.person),
                  ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OpeningHoursView(),
                  ),
                );
              },
              child: const Text("Horários de atendimento"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Link do site"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BusinessFormView()),
                );
              },
              child: const Text("Página do site"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountView(),
                  ),
                );
              },
              child: const Text("Configurações da conta"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Premium"),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService().logOut();
              },
              child: const Text("Sair"),
            ),
            ElevatedButton(
              onPressed: () {
                showConfirmationPassword(context: context, email: "");
              },
              child: const Text("Remover conta"),
            ),
          ],
        ),
      ),
    );
  }
}