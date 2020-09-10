import 'package:flutter/material.dart';
import 'package:kapa_app/Core/TextAreaValidator.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/LoginPage/Widgets/PictureWithText.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';

class VerifyNumber extends StatefulWidget {

  final bool isLogin;
  final String number;

  VerifyNumber({this.isLogin,this.number});
  @override
  State<StatefulWidget> createState() {
    return _VerifyNumberState(isLogin: isLogin, number: number);
  }
}

class _VerifyNumberState extends State<VerifyNumber> {
  bool codeSend = false;
  bool isLogin;
  String number;
  String verificationID;
  _VerifyNumberState({this.isLogin, this.number});

  BuildContext scaffoldBuildContext;

  AuthService authService = new AuthService();

  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController codeTEC = TextEditingController();
  bool _validate = false;
  @override
  void initState() {
    super.initState();
    if(number!=null)
    {
      phoneTEC.text = number;
    }
    else{
      phoneTEC.text="+380";
    }
  }

  @override
  Widget build(BuildContext context) {
    authService.context = context;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(),
      body: Builder(
        builder: (_buildContext) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child:
                    Image.asset('assets/images/LoginPage/Shape-18-copy-30.png'),
                  ),
                  isLogin ? Container(
                    width: size.width * 0.45,
                    height: size.height * 0.2,
                    child: PictureWithText(),
                  ) : Container(),
                  Form(
                    key: _key,
                    autovalidate: _validate,
                    child: codeSend
                        ? Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.white, decorationColor: Colors.white),
                          controller: codeTEC,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Код підтвердження',
                              labelStyle: TextStyle(color: Colors.white)),
                          validator: (String value) {
                            return validateTextArea(codeTEC.text);
                          },
                          keyboardType: TextInputType.number,
                        ))
                        : Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.white, decorationColor: Colors.white),
                          controller: phoneTEC,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Номер телефону',
                              labelStyle: TextStyle(color: Colors.white)),
                          validator: (String value) {
                            return validateMobile(value);
                          },
                          keyboardType: TextInputType.phone,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height*0.03),
                    child: SizedBox(
                      height: size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        onPressed: () {
                          scaffoldBuildContext = _buildContext;
                          codeSend ? loginWithOTP() : sendSMScode();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child:
                        Text(codeSend ? "Далі" : "Верифікувати", style: TextStyle(color: Colors.white)),
                        padding: EdgeInsets.all(8.0),
                        color: appThemeBlueMainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: appThemeBackgroundHexColor,
    );
  }

  loginWithOTP() {
    authService.signInWithOTP(codeTEC.text, verificationID, scaffoldBuildContext);
  }

  sendSMScode() //Send SMS code on press button verify
  async {
    if (_key.currentState.validate()) {
      print("Validated");
      authService.verifyPhone(phoneTEC.text,scaffoldBuildContext, isLogin);
      setState(() {
        codeSend = true;
      });
    }
    else{
      print("NOT Validated");
      setState(() {
        _validate = true;
      });
    }
  }
}
