import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirestoreServices._(); // private constructor
  static final instance = FirestoreServices._();
  final FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = fireStoreInstance.doc(path);
    await reference.set(data);
  }

  Future<void> deleteData({
    required String path,
  }) async {
    final reference = fireStoreInstance.doc(path);
    await reference.delete();
  }

  Future<DocumentSnapshot> getDocument({
    required String path,
  }) async {
    final reference = fireStoreInstance.doc(path);
    return reference.get();
  }

  Stream<T> documentsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final reference = fireStoreInstance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Stream<List<T>> collectionsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
    bool descending = false,
  }) {
    Query query = fireStoreInstance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map(
            (snapshot) => builder(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        ),
      )
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
}
