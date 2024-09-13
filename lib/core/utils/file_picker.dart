import 'package:fitoagricola/core/utils/permissions.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerComponent {
  static Future<List<XFile>?> pickImages(BuildContext context) async {
    dynamic selectType = await Dialogs.showGeralDialog(
      context,
      title: "Selecionar imagens",
      text: "Escolha a origem das suas imagens",
      widget: Column(
        children: [
          CustomOutlinedButton(
            text: "Câmera",
            onPressed: () {
              Navigator.pop(context, '1');
            },
            height: 45,
          ),
          const SizedBox(height: 5),
          CustomOutlinedButton(
            text: "Galeria",
            onPressed: () {
              Navigator.pop(context, "2");
            },
            height: 45,
          ),
        ],
      ),
    );

    if (selectType == null)
      return null; // Se usuário fechar o diálogo sem selecionar

    if (selectType == '0') {
      // Adicione a função que trata a captura pela câmera
      // return getFileFromCamera();
    } else if (selectType == '2') {
      return getFileFromGallery();
    }
    return null;
  }

  static Future<List<XFile>?> getFileFromGallery() async {
    bool storagePermission =
        await PermissionsComponent.checkAndRequestStoragePermission();

    if (storagePermission) {
      final ImagePicker _picker = ImagePicker();
      final List<XFile>? result = await _picker.pickMultiImage();

      return result;
    }

    return null;
  }

  static Future<XFile?> getFileFromCamera() async {
    bool cameraPermission =
        await PermissionsComponent.checkAndRequestCameraPermission();

    if (cameraPermission) {
      final ImagePicker _picker = ImagePicker();
      final XFile? result = await _picker.pickImage(source: ImageSource.camera);

      return result;
    }

    return null;
  }
}
