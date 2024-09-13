import 'dart:convert';
import 'dart:io';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/states_and_cities.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  Admin admin = PrefUtils().getAdmin();
  bool isSubmitting = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _selectedState;
  String? _selectedCity;
  List<Map<String, String>>? _states = [];
  List<Map<String, dynamic>>? _cities = [];

  Image imagePreview = Image.asset(
    "assets/images/file-placeholder.png",
    height: double.infinity,
    width: double.infinity,
    fit: BoxFit.cover,
  );
  dynamic changedImage;

  Key formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _states = LocationService.getStaticStates();

    if (admin.profilePicture != null && admin.profilePicture != "") {
      imagePreview = Image.network(
        "${dotenv.env['IMAGE_URL']}/admins/${admin.profilePicture}",
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    Future.delayed(Duration.zero, () {
      _initFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informações gerais",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              nameController,
              "Nome",
              "Digite seu nome",
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              emailController,
              "E-mail",
              "Digite seu e-mail",
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              phoneController,
              "Telefone",
              "Digite seu telefone",
              validatorFunction: false,
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              cpfController,
              "CPF",
              "Digite seu CPF",
              validatorFunction: false,
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              countryController,
              "País",
              "Digite seu país",
            ),
            const SizedBox(height: 10),
            // DropdownSearchComponent(
            //   // showSearch: false,
            //   items: _states != null
            //       ? _states!.map((e) {
            //           return DropdownSearchModel(
            //             id: e['id'],
            //             name: e['name'] ?? '--',
            //           );
            //         }).toList()
            //       : [],
            //   label: 'Estado',
            //   hintText: 'Selecione',
            //   selectedId: _selectedState,
            //   style: 'inline',
            //   onChanged: (value) {
            //     setState(() {
            //       _onStateChanged(value.id);
            //     });
            //   },
            // ),
            // const SizedBox(height: 10),
            // DropdownSearchComponent(
            //   // showSearch: false,
            //   items: _cities != null
            //       ? _cities!.map((e) {
            //           return DropdownSearchModel(
            //             id: e['id'],
            //             name: e['name'] ?? '--',
            //           );
            //         }).toList()
            //       : [],
            //   label: 'Cidade',
            //   hintText: 'Selecione',
            //   selectedId: _selectedCity,
            //   style: 'inline',
            //   onChanged: (value) {
            //     setState(() {
            //       _onCityChanged(value.id);
            //     });
            //   },
            // ),
            // const SizedBox(height: 10),
            CustomTextFormField(
              passwordController,
              "Senha",
              "Digite se quiser alterar sua senha",
              validatorFunction: false,
            ),

            const SizedBox(height: 25),
            Text(
              "Foto de perfil",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  setState(() {
                    changedImage = image;
                    imagePreview = Image.file(
                      File(image.path),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  });
                }
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imagePreview,
                ),
              ),
            ),
            const SizedBox(height: 25),
            CustomElevatedButton(
                text: "Salvar",
                isDisabled: isSubmitting,
                onPressed: () {
                  if ((formKey as GlobalKey<FormState>)
                      .currentState!
                      .validate()) {
                    _submitForm();
                  }
                }),
            // const SizedBox(height: 5),
            // CustomElevatedButton(
            //   text: "Excluir conta",
            //   isDisabled: isSubmitting,
            //   onPressed: () {
            //     Dialogs.showGeralDialog(
            //       context,
            //       title: "Excluir conta",
            //       text:
            //           "Deseja realmente excluir sua conta? Você será deslogado e não poderá mais acessar o aplicativo.",
            //       widget: Column(
            //         children: [
            //           CustomElevatedButton(
            //             text: "Excluir",
            //             onPressed: () async {
            //               LogoutFunctionOperation(context);

            //               try {
            //                 await launchUrl(
            //                     Uri.parse(
            //                         "${dotenv.env['SYSTEM_URL']}/excluir-conta"),
            //                     mode: LaunchMode.externalApplication);
            //               } catch (e) {
            //                 print(e);
            //               }
            //             },
            //           ),
            //           const SizedBox(height: 10),
            //           CustomOutlinedButton(
            //             text: "Cancelar",
            //             onPressed: () {
            //               Navigator.pop(context);
            //             },
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            //   buttonStyle: ButtonStyle(
            //     backgroundColor: MaterialStateColor.resolveWith(
            //       (states) => appTheme.red600,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _initFields() {
    nameController.text = admin.name;
    emailController.text = admin.email != null ? admin.email! : '';
    phoneController.text = admin.phone != null ? admin.phone! : '';
    cpfController.text = admin.cpf != null ? admin.cpf! : '';
    countryController.text = admin.country != null ? admin.country! : '';

    if (admin.state != null) {
      _selectedState = admin.state;
      _cities = LocationService.getStaticCities(admin.state!);
    }

    if (admin.city != null) {
      _selectedCity = admin.city;
    }
  }

  void _onStateChanged(String? stateId) {
    setState(() {
      _selectedState = stateId;
      _cities = LocationService.getStaticCities(stateId!);
      _selectedCity = null;
    });
  }

  void _onCityChanged(String? city) {
    setState(() {
      _selectedCity = city;
    });
  }

  _submitForm() async {
    setState(() {
      isSubmitting = true;
    });

    List<http.MultipartFile> files = [];

    if (changedImage != null) {
      files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        changedImage.path,
        filename: path.basename(changedImage.path),
        contentType: MediaType('image', path.extension(changedImage.path)),
      ));
    }

    Map<String, String> body = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "cpf": cpfController.text,
      "password": passwordController.text,
      "id": admin.id.toString(),
      "status": "1",
    };

    DefaultRequest.simplePostRequest(
      ApiRoutes.updateAdmin,
      body,
      context,
      isMultipart: true,
      files: files,
      offlineFiles: changedImage != null ? [changedImage] : [],
    ).then((value) {
      if (value) {
        DefaultRequest.simpleGetRequest(
          "${ApiRoutes.readAdmin}/${admin.id}",
          context,
          showSnackBar: 0,
        ).then((value) {
          final data = jsonDecode(value.body);

          if (data['admin'] != null) {
            PrefUtils().setAdmin(jsonEncode(data['admin']));
            print(PrefUtils().getAdmin().profilePicture);
            setState(() {
              admin = PrefUtils().getAdmin();
            });
          }
        });
      }
    }).catchError((error) {
      print(error);
    }).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
    });
  }
}
