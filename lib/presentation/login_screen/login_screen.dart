import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Trava a orientação para retrato ao entrar na página
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Libera a orientação ao sair da página
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              width: SizeUtils.width,
              height: SizeUtils.height,
              padding: Spacings.pagePadding,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login-bg-mobile.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: Spacings.loginPadding,
                    decoration: AppDecoration.loginDecoration,
                    width: double.maxFinite,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: isLogin ? LoginForm() : [],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 30.h),
              child: Image.asset(
                ImageConstant.logo,
                height: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  LoginForm() {
    return [
      Text(
        "Fito Agrícola",
        style: CustomTextStyles.bodyMediumSecondary,
      ),
      Text(
        "Bem vindo (a)",
        style: CustomTextStyles.headlineSmallOnWhite,
      ),
      const SizedBox(height: 30),
      _buildEmail(context),
      const SizedBox(height: 15),
      _buildPassword(context),
      const SizedBox(height: 15),
      SizedBox(
        height: 24,
        child: TextButton(
          onPressed: () async {
            try {
              await launchUrl(
                  Uri.parse(
                      "${dotenv.env['SYSTEM_URL']}/login?recuperar-senha=true"),
                  mode: LaunchMode.externalApplication);
            } catch (e) {
              print(e);
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          child: Text(
            "Esqueci minha senha",
            style: CustomTextStyles.bodyMediumWhiteUnderline,
          ),
        ),
      ),
      const SizedBox(height: 50),
      _buildLoginButton(context),
    ];
  }

  Widget _buildEmail(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          emailController,
          "E-mail",
          "- Digite seu e-mail -",
          inputType: TextInputType.emailAddress,
          labelStyle: CustomTextStyles.bodyMediumWhite,
          inputTextStyle: 'login',
        );
      },
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          passwordController,
          "Senha",
          "- Digite sua senha -",
          inputType: TextInputType.text,
          isPassword: true,
          labelStyle: CustomTextStyles.bodyMediumWhite,
          inputTextStyle: 'login',
        );
      },
    );
  }

  /// Section Widget
  Widget _buildLoginButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return CustomElevatedButton(
          text: "Entrar",
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF19D0BA),
          ),
          buttonTextStyle: CustomTextStyles.bodyLargeOnBlackBold,
          onPressed: () {
            loginToScreen(context);
          },
        );
      },
    );
  }

  loginToScreen(BuildContext context) async {
    bool hasInternet = await NetworkOperations.checkConnection();

    if (!hasInternet) {
      SnackbarComponent.showSnackBar(context, 'error',
          'Você não possui internet para realizar a operação');
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      await DefaultRequest.simplePostRequest(
        ApiRoutes.login,
        {
          'email': email,
          'password': password,
        },
        context,
        redirectFunction: () => {
          NavigatorService.pushNamedAndRemoveUntil(
            AppRoutes.homeScreen,
          )
        },
      );
    } else {
      SnackbarComponent.showSnackBar(
        context,
        'error',
        'Preencha todos os campos para continuar',
      );
    }
  }
}
