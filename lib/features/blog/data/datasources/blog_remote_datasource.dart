import 'dart:io';

import 'package:blog_app/core/error/exception.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage({
    required File image,
    required BlogModel blog,
  });

  Future<List<BlogModel>> fetchAllBlogs();
}

class BlogRemoteDatasourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final response =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      final blogData = response.first;
      return BlogModel.fromJson(blogData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(
      {required File image, required BlogModel blog}) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> fetchAllBlogs() async {
    try {
      final bloglistmap =
          await supabaseClient.from('blogs').select('* , profiles (name)');

      return bloglistmap
          .map(
            (blog) => BlogModel.fromJson(blog)
                .copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
