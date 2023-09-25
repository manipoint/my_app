import 'package:flutter/material.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_text.dart';



class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:40,left: 10,right: 10,bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: authController.email,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email_outlined),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Email"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: authController.password,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Password"),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:25,right: 25,top:25,bottom: 8),
            child: CustomButton(
              bgColor: Theme.of(context).colorScheme.background,
              text: "Login", onTap:()=> authController.signIn),
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: CustomText(
                  text: "Or SignIn with",
                  size: 20,
                  weight: FontWeight.bold,
                  color:  Colors.blueAccent,
                ),
              ),
              GestureDetector(
                onTap: () => authController.loginWithGoogle(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8,top:8),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/google.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
          

        ],
      ),
    );
  }
}
