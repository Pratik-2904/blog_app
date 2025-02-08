import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../datasources/blog_remote_datasource.dart';
import '../model/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    BlogModel blog = BlogModel(
      id: const Uuid().v1(),
      posterId: posterId,
      title: title,
      content: content,
      imageUrl: '',
      topics: topics,
      updatedAt: DateTime.now(),
      posterName: '',
    );

    try {
      final uploadedImageUrl = await blogRemoteDataSource.uploadImage(
        image: image,
        blog: blog,
      );

      blog = blog.copyWith(imageUrl: uploadedImageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blog);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> fetchAllBlogs() async {
    try {
      final res = await blogRemoteDataSource.fetchAllBlogs();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
