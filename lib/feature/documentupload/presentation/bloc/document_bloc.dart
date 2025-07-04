// lib/feature/documentupload/presentation/bloc/document_bloc.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/documentupload/data/repository/delete_document_repo_impl.dart';
import 'package:newsee/feature/documentupload/data/repository/get_document_repo_impl.dart';
import 'package:newsee/feature/documentupload/data/repository/get_image_repo_impl.dart';
import 'package:newsee/feature/documentupload/data/repository/upload_document_repo_impl.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final MediaService mediaService;

  DocumentBloc({required this.mediaService}) : super(DocumentState.initial()) {
    on<FetchDocumentsEvent>(_onFetchDocuments);
    on<AttachImageEvent>(_onAttachImage);
    on<DeleteDocumentImageEvent>(_onDeleteDocumentImage);
    on<UploadDocumentByIndexEvent>(_onUploadDocumentsByIndex);
    on<UploadDocumentByBytesEvent>(_onUploadDocumentByBytes);
    on<FetchDocumentImagesEvent>(_onFetchDocumentImages);
  }
  Future<void> _onFetchDocuments(
    FetchDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    print('jhdfd ${state.proposalNumber}');
    print('jhdfd2 ${event.proposalNumber}');
    emit(
      state.copyWith(
        proposalNumber: event.proposalNumber,
        fetchStatus: SubmitStatus.loading,
      ),
    );
    try {
      final responseHandler = await GetDocumentRepoImpl().getDocuments(
        request: {
          "userid": "AGRI1124",
          "vertical": "7",
          "token": ApiConfig.AUTH_TOKEN,
          "proposalNumber": event.proposalNumber,
        },
      );

      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        final rawList = response['documentdetails'] as List<dynamic>;
        final documents =
            rawList
                .map((e) => DocumentModel.fromMap(e as Map<String, dynamic>))
                .map((doc) => doc.copyWith(imgs: []))
                .toList();

        emit(
          state.copyWith(
            documentsList: documents,
            fetchStatus: SubmitStatus.success,
            uploadMessage: "Fetched Documents Successfully",
          ),
        );
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: "Fetched Document failure!",
          ),
        );
      }
    } catch (e) {
      print("Fetch failed: $e");
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: "Fetched failed: $e",
        ),
      );
    }
  }

  Future<void> _onAttachImage(
    AttachImageEvent event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final docs = [...state.documentsList];
      final doc = docs[event.docIndex];
      final count = doc.imgs.length + 1;
      File? file;

      if (event.source == FileSource.camera) {
        final imageBytes = await event.context.pushNamed<Uint8List>("camera");
        if (imageBytes != null) {
          final imagePath = await mediaService.saveBytesToFile(
            imageBytes,
            doc,
            count,
          );
          file = File(imagePath);
          await viewImageBeforeUpload(event, imageBytes);
        }
      } else if (event.source == FileSource.gallery) {
        final bytes = await mediaService.pickimagefromgallery(
          event.context,
          docIndex: event.docIndex,
        );
        if (bytes != null) {
          final imagePath = await mediaService.saveBytesToFile(
            bytes,
            doc,
            count,
          );
          file = File(imagePath);

          viewImageBeforeUpload(event, bytes);
        }
      } else if (event.source == FileSource.pdf) {
        final fileBytes = await mediaService.filePicker();
        if (fileBytes != null) {
          // Show preview or viewer for PDF
        }
      }

      // if (file != null) {
      //   final updatedImgs = [...doc.imgs]..add(
      //     DocumentImage(
      //       name: file.path.split('/').last,
      //       size: await file.length() / (1024 * 1024),
      //       path: file.path,
      //     ),
      //   );

      //   docs[event.docIndex] = doc.copyWith(imgs: updatedImgs);
      //   emit(state.copyWith(documentsList: docs));
      // }
    } catch (e) {
      print("Attach image error: $e");
    }
  }

  Future<void> viewImageBeforeUpload(
    AttachImageEvent event,
    Uint8List imageBytes,
  ) async {
    //preview before upload
    final result = await event.context.push(
      '/imageview',
      extra: {
        'imageBytes': imageBytes,
        'docIndex': event.docIndex,
        'isUploaded': state.isUploading,
      },
    );

    if (result != null && event.context.mounted) {
      add(
        UploadDocumentByBytesEvent(
          context: event.context,
          docIndex: event.docIndex,
          imageBytes: imageBytes,
        ),
      );
    }
  }

  Future<void> _onDeleteDocumentImage(
    DeleteDocumentImageEvent event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final docs = [...state.documentsList];
      final doc = docs[event.docIndex];
      final imgs = [...doc.imgs];

      if (event.imgIndex == null) {
        imgs.clear();
      } else if (event.imgIndex! >= 0 && event.imgIndex! < imgs.length) {
        imgs.removeAt(event.imgIndex!);
      }

      // docs[event.docIndex] = doc.copyWith(imgs: imgs);
      // emit(state.copyWith(documentsList: docs));

      final responseHandler = await DeleteDocumentRepoImpl().deleteUploadedDoc(
        request: {
          "proposalNumber": "143560000000682",
          "userid": "AGRI1124",
          "rowId": doc.lpdRowId,
          "token":
              "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
        },
      );

      if (responseHandler.isRight()) {
        doc.copyWith(lpdDocAction: 'P');
        docs[event.docIndex] = doc.copyWith(imgs: imgs);
        emit(
          state.copyWith(
            documentsList: docs,
            fetchStatus: SubmitStatus.success,
            uploadMessage: "Deleted Successfully",
          ),
        );
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: "Delete Document Failed!",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: "Delete Document error: $e",
        ),
      );
      print('Delete Document: $e');
    }
  }

  Future<void> _onUploadDocumentsByIndex(
    UploadDocumentByIndexEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final docs = [...state.documentsList];
    final doc = docs[event.docIndex];
    final updatedImgs = [...doc.imgs];

    emit(state.copyWith(fetchStatus: SubmitStatus.loading));

    for (int i in event.imgIndexes) {
      final image = updatedImgs[i];

      if (image.imgStatus == UploadStatus.uploading ||
          image.imgStatus == UploadStatus.success)
        continue;

      updatedImgs[i] = image.copyWith(imgStatus: UploadStatus.uploading);
      emit(state.updateImageStatus(event.docIndex, updatedImgs));

      try {
        final updatedDoc = await _uploadFile(File(image.path), doc);
        if (updatedDoc != null) {
          final updatedDocs = [...state.documentsList];
          updatedDocs[event.docIndex] = updatedDoc;
          emit(state.copyWith(documentsList: updatedDocs));
        }

        updatedImgs[i] = image.copyWith(imgStatus: UploadStatus.success);
        emit(state.copyWith(uploadMessage: "Upload Success"));
      } catch (e) {
        updatedImgs[i] = image.copyWith(imgStatus: UploadStatus.failed);
        emit(state.copyWith(uploadMessage: "Upload failed"));
      }

      emit(state.updateImageStatus(event.docIndex, updatedImgs));
    }

    emit(state.copyWith(fetchStatus: SubmitStatus.init));
  }

  Future<void> _onUploadDocumentByBytes(
    UploadDocumentByBytesEvent event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.loading,
          uploadMessage: 'Uploading Document...',
        ),
      );
      final doc = state.documentsList[event.docIndex];
      final count = doc.imgs.length + 1;
      final imagePath = await mediaService.saveBytesToFile(
        event.imageBytes,
        doc,
        count,
      );
      final file = File(imagePath);
      final updatedDoc = await _uploadFile(file, doc);

      if (updatedDoc != null) {
        final updatedDocs = [...state.documentsList];
        updatedDocs[event.docIndex] = updatedDoc;
        emit(
          state.copyWith(
            documentsList: updatedDocs,
            fetchStatus: SubmitStatus.success,
            uploadMessage: "Uploaded Successfully",
          ),
        );
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: "Upload failed",
          ),
        );
      }
    } catch (e) {
      print("Upload failed by bytes: $e");
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: "Upload error: $e",
        ),
      );
      // if (event.context.mounted) {
      //   ScaffoldMessenger.of(event.context).showSnackBar(
      //     const SnackBar(content: Text("Upload failed. Please try again.")),
      //   );
      // }
    }
  }

  Future<dynamic> _uploadFile(File file, DocumentModel doc) async {
    try {
      print("File size:${file.path},  ${await file.length()} bytes");
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'userid': 'AGRI1124',
        'proposalNumber': state.proposalNumber,
        'docid': '${doc.lpdDocId}${doc.lpdPartyId}',
        'partyType': doc.lpdPartyType,
        'docDesc': doc.lpdDocDesc,
        'token': ApiConfig.AUTH_TOKEN,
        'verticle': '7',
      });

      final responseHandler = await UploadDocumentRepoImpl().uploadDoc(
        request: formData,
      );

      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        final rawList = response['documentDetails'];
        // return doc.copyWith(lpdRowId: rawList[0]['ldaRowId']);
        if (rawList is List && rawList.isNotEmpty) {
          final updatedRowId = rawList[0]['ldaRowId'];
          return doc.copyWith(
            lpdRowId: updatedRowId.toString(),
            lpdDocAction: 'P',
          );
        } else {
          print("Upload succeeded but response has no documentdetails");
        }
      } else {
        final failure = responseHandler.left;
        print("Upload failed: $failure");
        throw Exception("Upload failed");
      }
    } catch (e) {
      print('_uploadFile: $e');
    }
  }

  Future<void> _onFetchDocumentImages(
    FetchDocumentImagesEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentList = [...state.documentsList];
    final doc = currentList[event.docIndex];

    try {
      emit(state.copyWith(fetchStatus: SubmitStatus.loading));

      // final images = await repository.fetchDocumentImages(doc); // Call API

      final responseHandler = await GetImageRepoImpl().fetchDocumentImage(
        request: {
          "userid": "AGRI1124",
          "rowId": doc.lpdRowId,
          "token": ApiConfig.AUTH_TOKEN,
          "proposalNumber": state.proposalNumber,
        },
      );

      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        final imgBase64 = response['file'] as String;
        if (imgBase64.isNotEmpty) {
          final imageBytes = base64Decode(imgBase64);
          final tempFile = await writeToFile(imageBytes);

          final docimg = [
            DocumentImage(
              name: tempFile.path.split('/').last,
              size: await tempFile.length() / (1024 * 1024),
              path: tempFile.path,
            ),
          ];
          final updatedDoc = doc.copyWith(imgs: docimg);
          currentList[event.docIndex] = updatedDoc;
          emit(
            state.copyWith(
              documentsList: currentList,
              fetchStatus: SubmitStatus.success,
              uploadMessage: 'Fetched Successfully',
            ),
          );
        }
      } else {
        final failure = responseHandler.left;
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: 'Fetched failed',
          ),
        );
        print("fetched failed: $failure");
        // throw Exception("fetched failed");
      }
    } catch (e) {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: 'Fetched error! $e',
        ),
      );
    }
  }

  Future<File> writeToFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    return await file.writeAsBytes(bytes);
  }
}
