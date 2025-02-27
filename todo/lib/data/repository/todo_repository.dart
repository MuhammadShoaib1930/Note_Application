import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/core/error/server_exception.dart';
import 'package:todo/core/locators/locator.dart';
import 'package:todo/core/utils/app_string.dart';
import 'package:todo/core/utils/appwrite_constants.dart';
import 'package:todo/data/model/todo_model.dart';
import 'package:todo/data/provider/appwrite_provider.dart';

abstract interface class ITodoRepository {
  Future<Either<Failure, Document>> addTodo({
    required String userId,
    required String title,
    required String description,
    required bool isCompleted,
  });
   Future<Either<Failure,List<TodoModel>>> getTodo({required String userId});
  Future<Either<Failure, Document>> editTodo({
    required String documentId,
    required String title,
    required String description,
    required bool isCompleted,
  });
   Future<Either<Failure,dynamic>> delteTodo({required String documentId});
}

class TodoRepository implements ITodoRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionChecker _internetConnectionChecker =
      locator<InternetConnectionChecker>();
  @override
  Future<Either<Failure, Document>> addTodo({
    required String userId,
    required String title,
    required String description,
    required bool isCompleted,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        String documentId = ID.unique();
        Document document = await _appwriteProvider.database!.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.todoCollectionId,
            documentId: documentId,
            data: {
              "userId": userId,
              "title": title,
              "description": description,
              "isCompleted": isCompleted,
              "id":documentId
            });
        return right(document);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure,List<TodoModel>>> getTodo({required String userId})async{
    try {
      if (await _internetConnectionChecker.hasConnection) {
        DocumentList list = await _appwriteProvider.database!.listDocuments(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.todoCollectionId,
            queries: [
              Query.equal("userId", userId)
            ]
            );
            Map<String,dynamic> data = list.toMap();
            List d = data['documents'].toList();
            List<TodoModel> todoList = d.map((e) => TodoModel.formMap(e['data'])).toList();
        return right(todoList);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Document>> editTodo({
    required String documentId,
    required String title,
    required String description,
    required bool isCompleted,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Document document = await _appwriteProvider.database!.updateDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.todoCollectionId,
            documentId: documentId,
            data: {
              "title": title,
              "description": description,
              "isCompleted": isCompleted,
              "id":documentId
            });
        return right(document);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
   Future<Either<Failure,dynamic>> delteTodo({required String documentId})
  async{
    try {
      if (await _internetConnectionChecker.hasConnection) {
        var response = await _appwriteProvider.database!.deleteDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.todoCollectionId,
            documentId: documentId
            );
        return right(response);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
