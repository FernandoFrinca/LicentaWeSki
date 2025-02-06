import 'package:flutter/material.dart';
import 'package:weski/Api/userApi.dart';
import '../Assets/Colors.dart';
import '../Assets/Theme.dart';
import '../Widget/CustomTextField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedCategory = "Skier";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void registerLogic() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String verifypassword = _verifyPasswordController.text;
    String email = _emailController.text;
    String category = selectedCategory;

    print('Username: $username');
    print('Password: $password');
    print('Verify-Password: $verifypassword');
    print('Email: $email');
    print('Category: $category');

    userApi.registerUser(username, email, password, category);
    Navigator.pop(context);
    //dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.17,
                child: Image(
                    image: AssetImage(
                        theme.brightness == lightTheme.brightness
                            ? "assets/goggles_lightmode.png"
                            : "assets/goggles_darkmode.png")),
              ),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              // CustomTextFormField widgets for Username, Email, Password, etc.
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.08,
                child: CustomTextField(
                  label: "Username",
                  controller: _usernameController,
                  icon: Icons.person_2_outlined,
                  borderColor: theme.colorScheme.onPrimary.value,
                  fillColor: theme.colorScheme.secondary.value,
                  iconColor: theme.colorScheme.primary.value,
                  texColor: theme.colorScheme.onSecondary.value,
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
                  label: "Email",
                  controller: _emailController,
                  icon: Icons.mail_outlined,
                  borderColor: theme.colorScheme.onPrimary.value,
                  fillColor: theme.colorScheme.secondary.value,
                  iconColor: theme.colorScheme.primary.value,
                  texColor: theme.colorScheme.onSecondary.value,
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
                  borderColor: theme.colorScheme.primary.value,
                  fillColor: theme.colorScheme.primary.value,
                  iconColor: theme.colorScheme.onPrimary.value,
                  texColor: theme.colorScheme.onPrimary.value,
                  borderRadius: 18,
                  errorState: false,
                  isPasswordField: true,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.08,
                child: CustomTextField(
                  label: "Verify-Password",
                  controller: _verifyPasswordController,
                  icon: Icons.vpn_key_outlined,
                  borderColor: theme.colorScheme.onPrimary.value,
                  fillColor: theme.colorScheme.secondary.value,
                  iconColor: theme.colorScheme.primary.value,
                  texColor: theme.colorScheme.onSecondary.value,
                  borderRadius: 18,
                  errorState: false,
                  isPasswordField: true,
                ),
              ),
              // Dropdown Button to select category
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category,
                    color: Color(theme.colorScheme.primary.value),
                    size: screenHeight * 0.03,
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  DropdownButton<String>(
                    hint: Text("Select Category"),
                    value: selectedCategory,
                    underline: SizedBox(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(theme.colorScheme.primary.value),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: "Skier", child: Text("Skier")),
                      DropdownMenuItem(
                          value: "Snowboarder", child: Text("Snowboarder")),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              // Register button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(licentaColors.opacity |
                  theme.colorScheme.primary.value),
                  foregroundColor: Color(licentaColors.opacity |
                  theme.colorScheme.onPrimary.value),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  registerLogic();
                  if (_emailController.text.isNotEmpty &&
                      _usernameController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty &&
                      _verifyPasswordController.text.isNotEmpty) {
                    registerLogic();
                  }
                },
                child: const Text('Register'),
              ),
              SizedBox(
                height: screenHeight * 0.002,
              ),
              Text(
                style: TextStyle(
                    color: Color(licentaColors.opacity |
                    theme.colorScheme.onSurface.value)),
                "Already have an account?",
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color(licentaColors.opacity |
                  theme.colorScheme.primary.value),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Log in now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
