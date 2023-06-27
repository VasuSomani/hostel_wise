import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_wise/Pages/HomePage.dart';
import '../Util/HexToColor.dart';
import 'package:http/http.dart' as http;
import '../Util/TextFieldAuth.dart';
import '../Util/httpCalls.dart';
import '../Util/MediaQuerry.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailID = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitData() async {
    final body = {
      "LOGIN": emailID.text,
      "PASSWORD": password.text,
    };
    final url = "$httpUrl/generallogin/";
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);
    if (response.statusCode == 202) {
      final ResponseBody = jsonDecode(response.body);
      print(response.body);
      final securityKey = ResponseBody["SECRETKEY"];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(ResponseBody)));
    } else {
      print("${response.statusCode}");
    }
  }

  void _authorize() {
    if (_formKey.currentState!.validate()) {
      _submitData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: Expanded(
            child: Image.asset(
              "assets/Icons/HostelWise.png",
            ),
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: HexColor("F7F7F7"),
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(100))),
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/Icons/graffiti.png",
            ),
          ),
          Align(
            heightFactor: 0.4,
            alignment: Alignment.bottomRight,
            child: Stack(
              children: [
                Container(
                  color: HexColor("#637892"),
                  height: Height(107, context),
                  width: Width(115, context),
                ),
                Container(
                  height: 107,
                  width: 115,
                  decoration: BoxDecoration(
                      color: HexColor("F7F7F7"),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(200))),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: HexColor("#637892"),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          TextFieldEmail(emailID),
                          const SizedBox(height: 20),
                          TextFieldPass(password),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _authorize,
                            style: ButtonStyle(
                                minimumSize:
                                    MaterialStatePropertyAll(Size(150, 50)),
                                backgroundColor: MaterialStatePropertyAll(
                                    HexColor("#FFEAD2"))),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an accout? ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/signup'),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
