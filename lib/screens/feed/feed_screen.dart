import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/cubits/liked_post/liked_posts_cubit.dart';
import 'package:instagram_bloc/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_bloc/utils/error_dialog.dart';
import 'package:instagram_bloc/widgets/post_view.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}



class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(e: state.failure),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Instagram'),
            actions: [
              if (state.posts.isEmpty && state.status == FeedStatus.loaded)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      context.read<FeedBloc>().add(FeedFetchPosts()),
                )
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

    Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            context.read<LikedPostsCubit>().clearAllLikedPosts();
             //return true;
          },
          child: ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = state.posts[index];
              final likedPostsState = context.watch<LikedPostsCubit>().state;
              final isLiked = likedPostsState.likedPostIds.contains(post.id);
              final recentlyLiked =
                  likedPostsState.recentlyLikedPostIds.contains(post.id);
              return PostView(
                post: post,
                isLiked: isLiked,
                recentlyLiked: recentlyLiked,
                onLike: () {
                  if (isLiked) {
                    context.read<LikedPostsCubit>().unlikePost(post: post);
                  } else {
                    context.read<LikedPostsCubit>().likePost(post: post);
                  }
                },
              );
            },
          ),
        );
    }
  }
}

// class _FeedScreenState extends State<FeedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         title: Text('Feeb / Home'),
//       ),
//       body: Center(child: Text('Home Feed'),),
//     );
//   }
// }