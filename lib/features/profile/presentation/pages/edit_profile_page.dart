import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/presentation/components/my_text_field.dart';
import 'package:social_bloc/features/profile/domain/entities/profile_user.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_bloc/responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // MOBILE IMAGE PICKER
  PlatformFile? imagePickedFile;

  // WEB IMAGE PICKER
  Uint8List? webImage;

  // BIO TEXT CONTROLLER
  final bioTextController = TextEditingController();

  // PICK IMAGE
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // UPDATE PROFILE BUTTON
  void updateProfile() {
    // PROFILE CUBIT
    final profileCubit = context.read<ProfileCubit>();

    // PREPARE IMAGE & DATA
    final String uid = widget.user.uid;
    final String? newBio = bioTextController.text.isNotEmpty
        ? bioTextController.text
        : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    // ONLY UPDATE PROFILE IF THERE'S NEW DATA
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }
    // IF NO NEW DATA TO UPDATE --> JUST GO TO PREVIOUS PAGE
    else {
      Navigator.pop(context);
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // PROFILE LOADING
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), Text("Uploading...")],
              ),
            ),
          );
        } else {
          // EDIT FORM
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // SAVE BUTTON
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload)),
        ],
      ),
      body: Column(
        children: [
          // PROFILE PICTURE
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,

              child:
                  // DISPLAY SELECTED IMAGE FOR MOBILE
                  (!kIsWeb && imagePickedFile != null)
                  ? Image.file(File(imagePickedFile!.path!), fit: BoxFit.cover)
                  :
                    // DISPLAY SELECTED IMAGE FOR WEB
                    (kIsWeb && webImage != null)
                  ? Image.memory(webImage!, fit: BoxFit.cover)
                  :
                    // NO IMAGE SELECTED --> DISPLAY CURRENT PROFILE PICTURE
                    CachedNetworkImage(
                      imageUrl: widget.user.profileImageUrl,
                      // LOADING...
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),

                      // ERROR (FAILED TO LOAD IMAGE) --> DISPLAY DEFAULT AVATAR
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      // LOADED IMAGE
                      imageBuilder: (context, imageProvider) =>
                          Image(image: imageProvider, fit: BoxFit.cover),
                    ),
            ),
          ),

          const SizedBox(height: 25),

          // PICK IMAGE BUTTON
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.green,
              child: const Text("Pick Image"),
            ),
          ),

          const SizedBox(height: 25),

          // BIO
          const Text("Bio"),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              hintText: widget.user.bio,
              obsureText: false,
              controller: bioTextController,
            ),
          ),
        ],
      ),
    );
  }
}
