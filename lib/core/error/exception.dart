//reason i have create this exception class is 
//if i want to add any more fields 
//like excetion stacks i will do it more easily
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}
