import 'package:test_app2/main.dart';
import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

final _formKey1 = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();

class _MyLoginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Stack(
          children: [
      Container(
      padding: EdgeInsets.only(left: 20, top: 150),
      child: const Text(
        'Welcome \nBack',
        style: TextStyle(color: Colors.white, fontSize: 33),
      ),
    ),
    SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
              right: 35,
              left: 35),
          child: Column(
            children: [
              Form(
                key: _formKey1,
                child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value != 'admin')
                        {return 'Please enter correct Username';
                        }
                      return null;
                    }
                ),),
              const SizedBox(
                height: 30,
              ),
            Form(
              key: _formKey2,
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value != 'admin'){
                      return 'Please enter correct Password';
                    }
                  }
              ),),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff4c505b)),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff4c505b),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (_formKey1.currentState!.validate() && _formKey2.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const MyApp()),
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              )
            ],

          ),

        )),
    ],
    )
    ,
    );
  }
}
