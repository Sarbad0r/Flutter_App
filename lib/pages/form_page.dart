import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _name;
    String? _email;
    String? _password;
    String? _url;
    String? _phoneNumber;
    String? _colories;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Widget _builedName() {
      return TextFormField(
        decoration: const InputDecoration(labelText: "Name"),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Name is required';
          }
        },
        onSaved: (value) {
          _name = value!;
        },
      );
    }

    Widget _builedEmail() {
      return TextFormField(
        decoration: const InputDecoration(labelText: "Email"),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(
                  "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$")
              .hasMatch(value)) {
            return 'Please Enter Email Adress';
          }
          return null;
        },
        onSaved: (value) {
          _email = value!;
        },
      );
    }

    Widget _builedPassword() {
      return TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(labelText: "Password"),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password is required';
          }
        },
        onSaved: (value) {
          _password = value!;
        },
      );
    }

    Widget _builedUrl() {
      return TextFormField(
        keyboardType: TextInputType.url,
        decoration: const InputDecoration(labelText: "Url"),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Url is required';
          }
        },
        onSaved: (value) {
          _url = value!;
        },
      );
    }

    Widget _builedFormNumber() {
      return TextFormField(
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(labelText: "Phone number"),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Phone number is required';
          }
        },
        onSaved: (value) {
          _phoneNumber = value!;
        },
      );
      ;
    }

    Widget _builedColories() {
      return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Calories"),
        validator: (value) {
          int? calories = int.tryParse(value!);
          if (calories == null || calories == 0) {
            return 'Calories must be grater than 0';
          }
        },
        onSaved: (value) {
          _colories = value!;
        },
      );
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Form Demo"),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(24),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _builedName(),
                      _builedEmail(),
                      _builedPassword(),
                      _builedUrl(),
                      _builedFormNumber(),
                      _builedColories(),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();
                            print(_name);
                            print(_email);
                            print(_password);
                          },
                          child: const Text(  
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ))
                    ],
                  )),
            ),
          ],
        ));
  }
}
