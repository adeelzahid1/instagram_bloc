import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/blocs/auth/auth_bloc.dart';
import 'package:instagram_bloc/models/post_model.dart';
import 'package:instagram_bloc/repositories/post/post_repository.dart';
import 'package:instagram_bloc/screens/comments/bloc/comments_bloc.dart';
import 'package:instagram_bloc/screens/profile/profile_screen.dart';
import 'package:instagram_bloc/screens/profile/widgets/profile_image.dart';
import 'package:instagram_bloc/utils/error_dialog.dart';
import 'package:intl/intl.dart';

class CommentsScreenArgs {
  final Post post;

  const CommentsScreenArgs({required this.post});
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = '/comments';

  static Route route({required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(CommentsFetchComments(post: args.post)),
        child: CommentsScreen(),
      ),
    );
  }
  
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(e: state.failure),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Comments')),
          body: ListView.builder(
            padding: const EdgeInsets.only(bottom: 60.0),
            itemCount: state.comments!.length,
            itemBuilder: (BuildContext context, int index) {
              final comment = state.comments![index];
              return ListTile(
                leading: UserProfileImage(
                  radius: 22.0,
                  profileImageUrl: comment!.author.profileImageUrl,
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: comment.author.username,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: comment.content),
                    ],
                  ),
                ),
                subtitle: Text(
                  DateFormat.yMd().add_jm().format(comment.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  ProfileScreen.routeName,
                  arguments: ProfileScreenArgs(userId: comment.author.id),
                ),
              );
            },
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == CommentsStatus.submitting)
                  const LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Write a comment...'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final content = _commentController.text.trim();
                        if (content.isNotEmpty) {
                          context
                              .read<CommentsBloc>()
                              .add(CommentsPostComment(content: content));
                          _commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}