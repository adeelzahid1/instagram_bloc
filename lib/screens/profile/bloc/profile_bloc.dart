import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/blocs/auth/auth_bloc.dart';
import 'package:instagram_bloc/cubits/liked_post/liked_posts_cubit.dart';
import 'package:instagram_bloc/models/failure_model.dart';
import 'package:instagram_bloc/models/post_model.dart';
import 'package:instagram_bloc/models/user_model.dart';
import 'package:instagram_bloc/repositories/post/post_repository.dart';
import 'package:instagram_bloc/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  final PostRepository _postRepository;
  final LikedPostsCubit _likedPostsCubit;
  late StreamSubscription<List<Future<Post?>?>> _postsSubscription;

  ProfileBloc({required UserRepository userRepository,required AuthBloc authBloc, required PostRepository postRepository, required LikedPostsCubit likedPostsCubit}) 
   : _userRepository = userRepository,  _postRepository = postRepository, _authBloc = authBloc, _likedPostsCubit = likedPostsCubit, super(ProfileState.initial()){

  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }


    on<ProfileLoadUser>( (event, emit) async{
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
        bool? isCurrentUser = _authBloc.state.user!.uid == event.userId;
        bool isFollowing = await _userRepository.isFollowing( userId: _authBloc.state.user!.uid,otherUserId: event.userId,);
 
        _postsSubscription.cancel();
        _postsSubscription = _postRepository.getUserPosts(userId: event.userId).listen((posts) async { 
          List<Future<Post?>?> allPosts = await Future.delayed(const Duration(seconds: 2), () => posts);  
          add(ProfileUpdatePosts(posts: allPosts as List<Post>));
        });

        emit(state.copyWith(user: user, isCurrentUser: isCurrentUser,isFollowing: isFollowing ,status: ProfileStatus.loaded,));
    } catch (err) {
          emit(state.copyWith(status: ProfileStatus.error, failure: const Failure(message: 'We were unable to load this profile.')));
        }
      }
    );

    on<ProfileToggleGridView>( (event, emit) {
      emit(state.copyWith(isGridView: event.isGridView));
      }
    );

    on<ProfileUpdatePosts>( (ProfileUpdatePosts event, Emitter<ProfileState> emit) async{
      final likedPostIds = await _postRepository.getLikedPostIds(
      userId: _authBloc.state.user!.uid,
      posts: event.posts,
    );
    _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      emit(state.copyWith(posts: event.posts));
      }
    );

    on<ProfileFollowUser>((event, emit) {
      try {
        _userRepository.followUser( userId: _authBloc.state.user!.uid, followUserId: state.user.id,);
        final updatedUser = state.user.copyWith(followers: state.user.followers + 1);
        emit(state.copyWith(user: updatedUser, isFollowing: true));
      } catch (err) {
          emit(state.copyWith(
            status: ProfileStatus.error, 
            failure: const Failure(message: 'Something went wrong! Please try again.'),),
          );
        }
    });

    on<ProfileUnfollowUser>((event, emit) {
      try {
      _userRepository.unfollowUser( userId: _authBloc.state.user!.uid, unfollowUserId: state.user.id,);
      final updatedUser = state.user.copyWith(followers: state.user.followers - 1);
       emit(state.copyWith(user: updatedUser, isFollowing: false));
      } catch (err) {
          emit(state.copyWith(
            status: ProfileStatus.error, 
            failure: const Failure(message: 'Something went wrong! Please try again.'),),
          );
        }
    });

    

  }






}

  //  Stream<ProfileState> _mapProfileToggleGridViewToState(
  //   ProfileToggleGridView event,
  // ) async* {
  //   yield state.copyWith(isGridView: event.isGridView);
  // }

  // Stream<ProfileState> _mapProfileUpdatePostsToState(
  //   ProfileUpdatePosts event,
  // ) async* {
  //   yield state.copyWith(posts: event.posts);
  // }


//   @override
//   Stream<ProfileState> mapEventToState(ProfileEvent event,) async* {
//     if (event is ProfileLoadUser) {
//       yield* _mapProfileLoadUserToState(event);
//     }
//   }

//   Stream<ProfileState> _mapProfileLoadUserToState(
//     ProfileLoadUser event,
//   ) async* {
//     yield state.copyWith(status: ProfileStatus.loading);
//     try {
//       final user = await _userRepository.getUserWithId(userId: event.userId);
//       final isCurrentUser = _authBloc.state.user!.uid == event.userId;

//       yield state.copyWith(user: user, isCurrentUser: isCurrentUser,status: ProfileStatus.loaded,);
//     } catch (err) {
//       yield state.copyWith( status: ProfileStatus.error, failure: const Failure(message: 'We were unable to load this profile.'),
//       );
//     }
//   }
// }
