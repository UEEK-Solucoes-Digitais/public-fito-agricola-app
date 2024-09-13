import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  String hintText;
  final TextInputType inputType;
  final bool isPassword;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final String? icon;
  final void Function()? iconFunction;
  final void Function()? tapFunction;
  final void Function(String)? onTextChanged;
  final bool validatorFunction;
  final bool readonly;
  final bool enabled;
  List<TextInputFormatter> formatters;
  final bool isFile;
  dynamic fileObject;
  dynamic changeParentFileObject;
  TextAlign textAlign;
  final bool focusNode;
  dynamic labelStyle;
  dynamic inputTextStyle;
  double? width;

  CustomTextFormField(
    this.controller,
    this.labelText,
    this.hintText, {
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.maxLength = 64,
    this.maxLines = 1,
    this.minLines = 1,
    this.icon,
    this.iconFunction,
    this.tapFunction,
    this.onTextChanged,
    this.validatorFunction = true,
    this.readonly = false,
    this.enabled = true,
    this.fileObject,
    this.changeParentFileObject,
    this.isFile = false,
    this.textAlign = TextAlign.start,
    this.focusNode = false,
    this.formatters = const [],
    this.labelStyle,
    this.width,
    this.inputTextStyle = 'primary',
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _passwordVisible = false;
  bool isError = false;
  String errorText = "";
  String hintText = "";
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          hintText = widget.hintText;

          if (widget.focusNode == true) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
        }));
  }

  getIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _passwordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: getIconColor(widget.inputTextStyle),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      );
    } else if (widget.icon != null && widget.iconFunction != null) {
      return IconButton(
        icon: PhosphorIcon(
          IconsList.getIcon(widget.icon ?? 'box'),
          color: getIconColor(widget.inputTextStyle),
          size: 20,
        ),
        onPressed: widget.iconFunction,
      );
    } else if (widget.icon != null) {
      return PhosphorIcon(
        IconsList.getIcon(widget.icon ?? 'box'),
        color: getIconColor(widget.inputTextStyle),
        size: 20,
      );
    } else {
      return null;
    }
  }

  // getTapFunction() {
  //   if (widget.tapFunction != null) {
  //     return widget.tapFunction;
  //   } else {
  //     return null;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != "")
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.labelText,
              style: widget.labelStyle ??
                  theme.textTheme.bodyLarge!.copyWith(
                    color: Color(0xFF152536),
                  ),
            ),
          ),
        Container(
          padding: getPadding(widget.inputTextStyle),
          decoration: getDecoration(widget.inputTextStyle, isError),
          width: widget.width ?? double.infinity,
          child: TextFormField(
            textAlignVertical: getIcon() != null
                ? TextAlignVertical.center
                : TextAlignVertical.top,
            style: getInputStyle(widget.inputTextStyle),
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              errorStyle: TextStyle(height: 0),
              counterText: '',
              hintStyle: getHintStyle(widget.inputTextStyle),
              border: InputBorder.none,
              suffixIcon: getIcon(),
            ),
            onTap: widget.tapFunction,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            keyboardType: widget.inputType,
            controller: widget.controller,
            readOnly: widget.readonly,
            onChanged: widget.onTextChanged,
            enabled: widget.enabled,
            // focusNode: _focusNode,
            obscureText: widget.isPassword && !_passwordVisible ? true : false,
            enableSuggestions:
                widget.isPassword && !_passwordVisible ? false : true,
            autocorrect: widget.isPassword && !_passwordVisible ? false : true,
            inputFormatters: widget.formatters,
            textAlign: widget.textAlign,
            validator: widget.validatorFunction
                ? (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isError = true;
                        errorText = 'Campo obrigatório';
                      });
                      return '';
                    } else if (widget.labelText.contains("Data") &&
                        widget.tapFunction == null &&
                        !Formatters.validateDate(value)) {
                      setState(() {
                        isError = true;
                        errorText = 'Data inválida';
                      });
                      return '';
                    } else {
                      setState(() {
                        isError = false;
                        errorText = "";
                      });
                    }
                    return null;
                  }
                : null,
          ),
        ),
        if (errorText != "")
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorText,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: appTheme.red600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

Color getIconColor(String type) {
  switch (type) {
    case 'primary':
      return appTheme.gray400;
    case 'login':
      return appTheme.whiteA70001;
    default:
      return appTheme.gray400;
  }
}

TextStyle getInputStyle(String type) {
  switch (type) {
    case 'primary':
      return theme.textTheme.bodyLarge!.copyWith(color: Colors.black);
    case 'primary-white':
      return theme.textTheme.bodyLarge!.copyWith(color: Colors.white);
    case 'secondary':
      return theme.textTheme.bodyMedium!;
    case 'login':
      return CustomTextStyles.bodyMediumWhite!;
    default:
      return theme.textTheme.bodyLarge!.copyWith(color: Colors.black);
  }
}

TextStyle getHintStyle(String type) {
  switch (type) {
    case 'primary':
      return CustomTextStyles.bodyLargeHintStyle!;
    case 'secondary':
      return theme.textTheme.bodyMedium!;
    case 'login':
      return CustomTextStyles.bodyMediumWhite!;
    default:
      return CustomTextStyles.bodyLargeHintStyle!;
  }
}

EdgeInsets getPadding(String type) {
  switch (type) {
    case 'primary':
      return const EdgeInsets.only(bottom: 0);
    case 'secondary':
      return const EdgeInsets.only(left: 15);
    case 'login':
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 2);
    default:
      return const EdgeInsets.only(bottom: 0);
  }
}

BoxDecoration getDecoration(String type, bool isError) {
  switch (type) {
    case 'primary':
      return BoxDecoration(
        color: Colors.transparent,
        border: Border(
            bottom: BorderSide(
          color: isError ? appTheme.red600 : appTheme.gray400,
          width: 1,
        )),
      );
    case 'secondary':
      return BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: isError ? appTheme.red600 : appTheme.gray400),
        borderRadius: BorderRadius.circular(30),
      );
    case 'login':
      return BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: isError ? appTheme.red600 : appTheme.gray300),
        borderRadius: BorderRadius.circular(30),
      );
    default:
      return BoxDecoration(
        color: Colors.transparent,
        border: Border(
            bottom: BorderSide(
          color: isError ? appTheme.red600 : appTheme.gray400,
          width: 1,
        )),
      );
  }
}
