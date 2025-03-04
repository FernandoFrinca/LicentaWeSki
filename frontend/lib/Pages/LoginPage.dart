import 'package:flutter/material.dart';
import 'package:weski/Api/userApi.dart';

import '../Assets/Colors.dart';
import '../Assets/Theme.dart';
import '../ConcretObjects/User.dart';
import '../Widget/CustomTextField.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<User?> loginLogic() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    return userApi.userLoginValidation(username, password);
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    User? currentUser;

    @override
    void dispose() {
      _usernameController.dispose();
      _passwordController.dispose();
    }

    Future<User?> loginLogic() async{
      String username = _usernameController.text;
      String password = _passwordController.text;

      return userApi.userLoginValidation(username, password);

      //dispose();
    }

    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.17,
                //color: theme.colorScheme.primary,
                //child: Image(image: AssetImage("assets/goggles_darkmode.png"),),
                child: Image(image: AssetImage(theme.brightness == lightTheme.brightness? "assets/goggles_lightmode.png": "assets/goggles_darkmode.png")),
              ),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.08,
                child: CustomTextField(
                  label: "Username",
                  controller: _usernameController,
                  icon: Icons.person_2_outlined,
                  borderColor: theme.colorScheme.primary.value,
                  fillColor: theme.colorScheme.primary.value,
                  iconColor: theme.colorScheme.onPrimary.value,
                  texColor: theme.colorScheme.onPrimary.value,
                  borderRadius: 18,
                  errorState: false,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.08,
                child: CustomTextField(
                  label: "Password",
                  controller: _passwordController,
                  icon: Icons.vpn_key_outlined,
                  borderColor: theme.colorScheme.secondary.value,
                  fillColor: theme.colorScheme.secondary.value,
                  iconColor: theme.colorScheme.primary.value,
                  texColor: theme.colorScheme.onSecondary.value,
                  borderRadius: 18,
                  errorState: false,
                  isPasswordField: true,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(licentaColors.opacity | theme.colorScheme.primary.value),
                    foregroundColor: Color(licentaColors.opacity | theme.colorScheme.onPrimary.value),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    currentUser = await loginLogic();
                    if(currentUser != null){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(curentUser: currentUser!),
                        ),
                      );
                    }
                    else{

                    }
                  },
                  child: const Text('Log In'),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                  style:TextStyle(
                    color: Color(licentaColors.opacity | theme.colorScheme.onSurface.value),
                  ),
                  "Does not have an account?"
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color(licentaColors.opacity | theme.colorScheme.primary.value),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: Text('Register now'),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color(licentaColors.opacity | theme.colorScheme.primary.value),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  User testUser = User(
                    id: 999,
                    username: 'testUser',
                    email: 'dummy@example.com',
                    age: 30,
                    gender: 1,
                    category: 'Tester',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(curentUser: testUser),
                    ),
                  );
                },
                child: Text('test->mainPage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
