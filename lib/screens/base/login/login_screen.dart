import 'package:flutter/material.dart';
import 'package:lojavirtualapp/models/user.dart';
import 'package:lojavirtualapp/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:lojavirtualapp/helpers/validators.dart';

class LoginScreen extends StatelessWidget {
  //Comando para enviar os dados para o Firebase.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  //Comando para validar os campos email e senha.
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  //Comando para mostrar o erro ao fazer o login.
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              textColor: Colors.white,
              child: const Text(
                'CRIAR CONTA',
                style: TextStyle(fontSize: 14),
              ))
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValid(email)) return 'E-mail invalido';
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty || pass.length < 6)
                          return 'Senha invalida';
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          formkey.currentState.validate();
                        },
                        padding: EdgeInsets.zero,
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (formkey.currentState.validate()) {
                                    userManager.signIn(
                                        user: User(
                                          email: emailController.text,
                                          password: passController.text,
                                        ),
                                        onFail: (e) {
                                          scaffoldkey.currentState
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Falha ao entrar: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        },
                                        onSuccess: () {
                                          Navigator.of(context).pop();
                                        });
                                  }
                                },
                          color: Theme.of(context).primaryColor,
                          disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          child: userManager.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 18),
                                ),
                        )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
