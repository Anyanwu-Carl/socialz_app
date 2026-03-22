import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/domain/entity/app_user.dart';
import 'package:social_bloc/features/auth/presentation/components/my_text_field.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/features/post/domain/entities/post.dart';
import 'package:social_bloc/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_bloc/features/post/presentation/cubits/posts_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // Mobile image picker
  PlatformFile? imagePickedFile;

  // Web image picker
  Uint8List? webImage;

  // Text controller
  final textController = TextEditingController();

  // Current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  // Get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

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

  // CREATE AND UPLOAD POST
  void uploadPost() {
    // CHECK IF BOTH IMAGE AND CAPTION ARE PROVIDED
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are required")),
      );
      return;
    }

    // Create a new post object
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: "",
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // Post cubit
    final postCubit = context.read<PostCubit>();

    // Web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    // Mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // BLOC CONSUMER --> Builder, listener
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        // LOADING OR UPLOADING
        if (state is PostsLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // BUILD UPLOAD PAGE
        return buildUploadPage();
      },

      // GOTO PREVIOUS PAGE WHEN UPLOAD IS DONE AND POST ARE LOADED
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    // Scaffold
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Create Post"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload)),
        ],
      ),
      body: Column(
        children: [
          // Image preview for web
          if (kIsWeb && webImage != null) Image.memory(webImage!),

          // Image preview for mobile
          if (!kIsWeb && imagePickedFile != null)
            Image.file(File(imagePickedFile!.path!)),

          // PICK IMAGE BUTTON
          MaterialButton(
            onPressed: pickImage,
            color: Colors.blue,
            child: const Text("Pick Image"),
          ),

          // CAPTION TEXTBOX
          MyTextField(
            hintText: "Caption",
            obsureText: false,
            controller: textController,
          ),
        ],
      ),
    );
  }
}
