
import 'package:appwrite/appwrite.dart';
import 'package:todo/core/utils/appwrite_constants.dart';

class AppwriteProvider {
  Client client = Client();
  Account? account;
  Databases? database;

  AppwriteProvider(){
    client.setEndpoint(AppwriteConstants.endPoint)
    .setProject(AppwriteConstants.projectId)
    .setSelfSigned(status: true);
    account = Account(client);
    database = Databases(client);
  }
}