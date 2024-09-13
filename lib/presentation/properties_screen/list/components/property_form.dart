import 'dart:convert';

// import 'package:estados_municipios/estados_municipios.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';

class PropertyForm extends StatefulWidget {
  final int propertyId;
  final Function() reloadFunction;

  const PropertyForm(
    this.propertyId,
    this.reloadFunction, {
    super.key,
  });

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  bool isLoading = true;
  Admin currentAdmin = PrefUtils().getAdmin();
  List<Admin> admins = [
    Admin(id: 0, name: 'Selecione o proprietário', accessLevel: 0),
  ];
  bool isLoadingAdmins = true;
  Property? property;

  final _formKey = GlobalKey<FormState>();

  // final statesController = EstadosMunicipiosController();
  // List states = [];
  // List cities = [];

  List<Map<String, dynamic>> fields = [
    {
      "name": 'name',
      "label": 'Nome da propriedade',
      "hint": "Digite o nome da propriedade",
      "controller": '',
    },
    {
      "name": 'adminId',
      "label": 'Proprietário',
      "value": 0,
    },
    {
      "name": 'stateSubscription',
      "label": 'Inscrição estadual',
      "hint": "Digite a inscrição estadual",
      "controller": '',
    },
    {
      "name": 'cep',
      "label": 'CEP',
      "hint": "Digite o CEP",
      "controller": '',
    },
    {
      "name": 'street',
      "label": 'Logradouro',
      "hint": "Digite o logradouro",
      "controller": '',
    },
    {
      "name": 'uf',
      "label": 'Estado',
      "value": null,
    },
    {
      "name": 'city',
      "label": 'Município',
      "value": null,
    },
    {
      "name": 'neighborhood',
      "label": 'Bairro',
      "hint": "Digite o bairro",
      "controller": '',
    },
    {
      "name": 'number',
      "label": 'Número',
      "hint": "Digite o número",
      "controller": '',
    },
    {
      "name": 'complement',
      "label": 'Complemento',
      "hint": "Digite o complemento",
      "controller": '',
    },
    {
      "name": 'cnpj',
      "label": 'CNPJ',
      "hint": "Digite o CNPJ",
      "controller": '',
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      getProperty();
      // states = await statesController.buscaTodosEstados();
      getAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                for (var field in fields)
                  if (!['adminId', 'uf', 'city'].contains(field['name']))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CustomTextFormField(
                        field['controller'],
                        field['label'],
                        field['hint'],
                        validatorFunction: field['name'] == 'name',
                      ),
                    )
                  else if (field['name'] == 'adminId')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownSearchComponent(
                        items: admins
                            .map((e) =>
                                DropdownSearchModel(id: e.id, name: e.name))
                            .toList(),
                        label: 'Proprietário',
                        hintText: 'Selecione o proprietário',
                        selectedId: field['value'],
                        style: 'inline',
                        onChanged: (value) => {
                          setState(() {
                            field['value'] = value.id;
                          })
                        },
                      ),
                    ),
                // else if (field['name'] == 'uf' && states.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 15),
                //     child: DropdownSearchComponent(
                //       items: states
                //           .map((e) =>
                //               DropdownSearchModel(id: e.sigla, name: e.nome))
                //           .toList(),
                //       label: 'Estado',
                //       hintText: 'Selecione o estado',
                //       selectedId: field['value'],
                //       style: 'inline',
                //       onChanged: (value) async {
                //         field['value'] = value.id;
                //         cities = await statesController
                //             .buscaMunicipiosPorEstado(value.id);
                //         print(cities);

                //         setState(() {});
                //       },
                //     ),
                //   )
                // else if (field['name'] == 'city' && cities.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 15),
                //     child: DropdownSearchComponent(
                //       items: cities
                //           .map(
                //             (e) =>
                //                 DropdownSearchModel(id: e.nome, name: e.nome),
                //           )
                //           .toList(),
                //       label: 'Município',
                //       hintText: 'Selecione o município',
                //       selectedId: field['value'],
                //       style: 'inline',
                //       onChanged: (value) => {
                //         setState(() {
                //           field['value'] = value.id;
                //         })
                //       },
                //     ),
                //   ),
                CustomFilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitForm();
                    }
                  },
                  text: "Editar",
                ),
                const SizedBox(height: 10),
                CustomOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Cancelar",
                )
              ],
            ),
          );
  }

  initFields() async {
    if (property == null) {
      return;
    }
    for (var field in fields) {
      // switch do field name
      switch (field['name']) {
        case 'name':
          field['controller'] = TextEditingController(text: property!.name);
          break;
        case 'adminId':
          field['value'] = property!.adminId;
          break;
        case 'stateSubscription':
          field['controller'] =
              TextEditingController(text: property!.stateSubscription);
          break;
        case 'cep':
          field['controller'] = TextEditingController(text: property!.cep);
          break;
        case 'street':
          field['controller'] = TextEditingController(text: property!.street);
          break;
        // case 'uf':
        //   field['value'] = property!.uf;

        //   if (property!.uf != null && property!.uf!.isNotEmpty) {
        //     cities =
        //         await statesController.buscaMunicipiosPorEstado(property!.uf!);
        //   }
        //   break;
        // case 'city':
        //   field['value'] = property!.city;
        //   break;
        case 'neighborhood':
          field['controller'] =
              TextEditingController(text: property!.neighborhood);
          break;
        case 'number':
          field['controller'] =
              TextEditingController(text: property!.number.toString());
          break;
        case 'complement':
          field['controller'] =
              TextEditingController(text: property!.complement);
          break;
        case 'cnpj':
          field['controller'] = TextEditingController(text: property!.cnpj);
          break;
        default:
          break;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  getProperty() async {
    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.readProperties}/${widget.propertyId}?read_miminum=true",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        property = Property.fromJson(data['property']);
        isLoadingAdmins = false;
      });

      initFields();
    }).catchError((error) {
      print(error);
      Navigator.pop(context);
    });
  }

  getAdmins() async {
    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listAdmins}/${currentAdmin.id}",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        admins = [
          Admin(id: 0, name: 'Selecione o proprietário', accessLevel: 0),
          ...Admin.fromJsonList(data['admins'])
        ];
        isLoadingAdmins = false;
      });
    });
  }

  void submitForm() {
    if (fields[1]['value'] == 0 ||
        fields[1]['value'] == null ||
        fields[1]['value'] == '') {
      SnackbarComponent.showSnackBar(
          context, 'alert', "Selecione um proprietário para continuar.");
      return;
    }

    if (fields[5]['value'] == '' || fields[6]['value'] == '') {
      SnackbarComponent.showSnackBar(
          context, 'alert', "Informe o estado e o município para continuar.");
      return;
    }

    final data = {
      "id": widget.propertyId,
      "name": fields[0]['controller'].text,
      "admin_id": fields[1]['value'],
      "state_subscription": fields[2]['controller'].text,
      "cep": fields[3]['controller'].text,
      "street": fields[4]['controller'].text,
      "uf": fields[5]['value'],
      "city": fields[6]['value'],
      "neighborhood": fields[7]['controller'].text,
      "number": fields[8]['controller'].text,
      "complement": fields[9]['controller'].text,
      "cnpj": fields[10]['controller'].text,
    };

    DefaultRequest.simplePostRequest(
      "${ApiRoutes.formProperties}",
      data,
      context,
      redirectFunction: () {
        widget.reloadFunction();
        Navigator.pop(context);
      },
    );
  }
}
