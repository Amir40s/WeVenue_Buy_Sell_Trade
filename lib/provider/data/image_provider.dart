import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickProvider extends ChangeNotifier {

  Uint8List? _imageBytes;
  File? _imageFile;
  String? _imagePath;

  File? productImage;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  List<String> _downloadUrls = [];

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  List<XFile>? get images => _images;
  List<String> get downloadUrls => _downloadUrls;

  Uint8List? get imageBytes => _imageBytes;

  File? get imageFile => _imageFile;

  String? get imagePath => _imagePath;


  ImagePickProvider(){
   clear();
  }

  pickProductImage() async {
    var imageData = await baseImagePicker();
    _imageFile = imageData;
  }

  Future<File?> baseImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var image = File(pickedFile.path);
      return image;
    } else {
      return null;
    }
  }

  Future<String?> uploadImage({required imageFile}) async {
    if (imageFile == null) return null;

    Reference ref = FirebaseStorage.instance.ref().child(
        'images/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(imageFile!);

    TaskSnapshot storageTaskSnapshot = await uploadTask;
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
      notifyListeners();
    });

    try {
      await uploadTask;
    } catch (e) {
      rethrow;
    } finally {
      resetUploadProgress();
    }
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }



  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      _images = selectedImages;
      notifyListeners();
    }
  }

  Future<void> uploadImages(BuildContext context) async {
    if (_images == null || _images!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No images selected')),
      );
      return;
    }

    _downloadUrls = [];
    for (XFile image in _images!) {
      File file = File(image.path);
      try {
        Reference ref = FirebaseStorage.instance
            .ref('uploads/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
        await ref.putFile(file);

        String downloadUrl = await ref.getDownloadURL();
        _downloadUrls.add(downloadUrl);
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload: ${e.message}')),
        );
      }
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Upload complete')),
    // );
    // clear();
    notifyListeners();
  }



  void resetUploadProgress() {
    _uploadProgress = 0.0;
    notifyListeners();
  }


  void clear(){
    _downloadUrls.clear();
    _images!.clear();
    _imageBytes = null;
    _imageFile = null;
    _imagePath = null;
    notifyListeners();
  }


}