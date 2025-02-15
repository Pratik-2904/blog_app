import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../datasources/blog_remote_datasource.dart';
import '../model/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogLocalDatasource blogLocalDatasource;
  final ConnectionChecker connectionChecker;
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDatasource,
    this.connectionChecker,
  );

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
      if (!await (connectionChecker.hasConnection)) {
        return left(Failure("No Internet Connection"));
      }
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
      if (!await (connectionChecker.hasConnection)) {
        final blogs = blogLocalDatasource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.fetchAllBlogs();
      blogLocalDatasource.uploadBlogs(blogs: blogs); //blogs uploaded to local storage
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
