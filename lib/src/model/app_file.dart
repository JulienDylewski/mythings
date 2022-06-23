import 'package:my_things/src/service/backend/storage_service.dart';

class AppFile {
  AppFile({required this.ref, required this.name,  this.downloadUrl});

  String ref;
  String name;

  String?  downloadUrl;

  String  get safeDownloadUrl  {
    return downloadUrl ??  "https://firebasestorage.googleapis.com/v0/b/mythings-app.appspot.com/o/no-image-featured-image.png?alt=media&token=b2e08609-f293-42ef-bd1b-b7803eae1ace";
  }

  Map<String, Object?> toJson() {
    return {
      'ref': ref,
      'name': name,
      'downloadUrl': downloadUrl

    };
  }

  AppFile.fromJson(Map<String, dynamic> json): this(
      ref: json['ref']! ,
      name: json['name'],
      downloadUrl: json['downloadUrl']
  );
}

