import 'package:flutter/material.dart';

class BlogEditor extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final int? maxLines;

  const BlogEditor({
    super.key,
    required this.textController,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  State<BlogEditor> createState() => _BlogEditorState();
}

class _BlogEditorState extends State<BlogEditor> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      decoration: InputDecoration(
        hintText: widget.hintText,
        
      ),
      maxLines: widget.maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '${widget.hintText} is missing!';
        }
        return null;
      },
    );
  }
}
