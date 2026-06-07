import 'package:evex_user/features/posts/data/models/post.dart';
import 'package:evex_user/features/posts/data/repos/post_repo.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final PostRepo postRepo;
  PostController(this.postRepo);
  RxList<Post> posts = RxList<Post>([]);

  var isLoading = false.obs;

  getPosts() async {
    isLoading.value = true;
    final result = await postRepo.getPosts();
    isLoading.value = false;
    result.fold(
      (error) {
        print(error.message);
      },
      (r) {
        posts.value = r;
      },
    );
  }

  @override
  void onInit() {
    getPosts();
    super.onInit();
  }
}
