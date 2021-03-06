import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_bloc/config/path.dart';
import 'package:instagram_bloc/models/notify_model.dart';
import 'package:instagram_bloc/repositories/notification/base_notification_repository.dart';
import 'package:meta/meta.dart';

class NotificationRepository extends BaseNotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notif>>> getUserNotifications({required String userId}) {
    return _firebaseFirestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList()  as List<Future<Notif>>,
          // (snap) => snap.docs.map((doc) => [] as List<Future<Notif>>,
        );
  }
}