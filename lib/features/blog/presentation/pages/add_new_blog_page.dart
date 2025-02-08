import 'dart:io';

import 'package:blog_app/core/comman/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/comman/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallate.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;
  List<String> selectedTopics = [];

  void selectImage() async {
    final pickimage = await pickImage();
    if (pickimage != null) {
      setState(() {
        image = pickimage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      // Debug prints
      // print('Form is valid');
      // print('Selected Topics: $selectedTopics');
      // print('Image: ${image!.path}');
      
      final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
          .user
          .id; // check this again

      // print('Poster ID: $posterId');

      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
            ),
          );
    } else {
      // print('Form is invalid or missing data');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Blog"),
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(CupertinoIcons.checkmark_alt_circle),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSucess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey, // validation will not occur when the validation key is not there.
              child: SingleChildScrollView(
                child: Column(
                  //main column
                  children: [
                    //Dotted Box
                    image == null
                        ? GestureDetector(
                            onTap:
                                selectImage, // use this function to select image
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [15, 4],
                              radius: const Radius.circular(10),
                              child: const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // Inner Column for image selector
                                  children: [
                                    Icon(Icons.folder_open),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select Your Image",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: FileImage(image!),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                    const SizedBox(height: 2),
              
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Science',
                          'Business',
                          'programming',
                          'Entertainment',
                        ]
                            .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5)
                                    .copyWith(right: 5),
                                child: GestureDetector(
                                  onTap: () => {
                                    if (selectedTopics.contains(e))
                                      {
                                        selectedTopics.remove(e),
                                      }
                                    else
                                      {
                                        selectedTopics.add(e),
                                      },
                                    setState(() {})
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1)
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                )))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
              
                    BlogEditor(
                      textController: titleController,
                      hintText: 'Blog Title',
                    ),
              
                    const SizedBox(height: 10),
              
                    BlogEditor(
                      textController: contentController,
                      hintText: 'Content',
                      maxLines: null,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
