import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/blocs/auth/auth_bloc.dart';
import 'package:instagram_bloc/models/failure_model.dart';
import 'package:instagram_bloc/models/post_model.dart';
import 'package:instagram_bloc/models/user_model.dart';
import 'package:instagram_bloc/repositories/post/post_repository.dart';
import 'package:instagram_bloc/repositories/user/base_user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  final PostRepository _postRepository;
  late StreamSubscription<List<Future<Post?>?>> _postsSubscription;

  ProfileBloc({required UserRepository userRepository,required AuthBloc authBloc, required PostRepository postRepository}) 
   : _userRepository = userRepository,  _postRepository = postRepository, _authBloc = authBloc, super(ProfileState.initial()){

  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }


    on<ProfileLoadUser>( (event, emit) async{
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
        final isCurrentUser = _authBloc.state.user!.uid == event.userId;

        _postsSubscription.cancel();
        _postsSubscription = _postRepository.getUserPosts(userId: event.userId).listen((posts) async { 
          List<Future<Post?>?> allPosts = await Future.delayed(const Duration(seconds: 2), () => posts);  
          add(ProfileUpdatePosts(posts: allPosts as List<Post>));
        });

        emit(state.copyWith(user: user, isCurrentUser: isCurrentUser,status: ProfileStatus.loaded,));
    } catch (err) {
          emit(state.copyWith(status: ProfileStatus.error, failure: const Failure(message: 'We were unable to load this profile.')));
        }
      }
    );

    on<ProfileToggleGridView>( (event, emit) {
      emit(state.copyWith(isGridView: event.isGridView));
      }
    );

    on<ProfileUpdatePosts>( (ProfileUpdatePosts event, Emitter<ProfileState> emit) {
      emit(state.copyWith(posts: event.posts));
      }
    );

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
