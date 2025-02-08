import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/blog_repository.dart';

class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
  final BlogRepository repository;

  GetAllBlogs(this.repository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    final res = await repository.fetchAllBlogs();
    return res;
  }
}
