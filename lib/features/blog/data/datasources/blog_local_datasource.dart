import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDatasource {
  void uploadBlogs({
    required List<BlogModel> blogs,
  });

  List<BlogModel> loadBlogs();
}

class BlogLocalDatasourceImpl implements BlogLocalDatasource {
  final Box box;

  BlogLocalDatasourceImpl(this.box);
  //None of the methos here is future becoz hive is offfline

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        // blogs.add(box.get(i.toString())); //this is gonna reaturn the blogs in jason format we dont want that
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadBlogs({
    required List<BlogModel> blogs,
  }) {
    box.clear();
    // when you have bunch of the blogs to upload use write
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
