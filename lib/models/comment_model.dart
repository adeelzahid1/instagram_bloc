import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_bloc/config/path.dart';
import 'package:instagram_bloc/models/user_model.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final User author;
  final String content;
  final DateTime date;
  
  const Comment({
    required this.id,
    required this.postId,
    required this.author,
    required this.content,
    required this.date,
  });



  @override
  List<Object> get props {return [id,postId,author,content, date,];
  }

  Comment copyWith({
    String? id,
    String? postId,
    User? author,
    String? content,
    DateTime? date,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'postId': postId,
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }


  static Future<Comment?>? fromDocument(DocumentSnapshot? doc) async {
    if (doc == null) return null;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DocumentReference<Object?> authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Comment(
          id: doc.id,
          postId: data['postId'] ?? '',
          author: User.fromDocument(authorDoc),
          content: data['content'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }


}
