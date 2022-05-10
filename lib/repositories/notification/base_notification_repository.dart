import 'package:instagram_bloc/models/notify_model.dart';

abstract class BaseNotificationRepository {
  Stream<List<Future<Notif>>> getUserNotifications({required String userId});
}