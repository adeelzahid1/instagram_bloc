import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_bloc/config/path.dart';
import 'package:instagram_bloc/models/post_model.dart';
import 'package:instagram_bloc/models/comment_model.dart';
import 'package:instagram_bloc/repositories/post/base_post_repository.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createComment({required Comment comment}) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());
  }

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

   @override
  Stream<List<Future<Post?>?>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }


  @override
  Stream<List<Future<Comment?>?>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

    @override
  Future<Set<List<Post>>> getUserFeed({required String userId}) async {
    final postsSnap = await _firebaseFirestore
        .collection(Paths.feeds)
        .doc(userId)
        .collection(Paths.userFeed)
        .orderBy('date', descending: true)
        .get();
        final posts = Future.delayed(const Duration(seconds: 2), () => {
          postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList() as List<Post>
        });
    //final posts = Future.wait(postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),);
    return posts;
  }

}