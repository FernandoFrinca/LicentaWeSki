import 'package:flutter/material.dart';
import '../Assets/Colors.dart';
import '../Assets/Theme.dart';
import '../Widget/CustomTextField.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                child: Image(image: AssetImage(theme.brightness == lightTheme.brightness? "assets/goggles_lightmode.png": "assets/goggles_darkmode.png")),
              ),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.08,
                child: CustomTextFormField(
                  label: "Username",
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
                child: CustomTextFormField(
                  label: "Email",
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
                child: CustomTextFormField(
                  label: "Password",
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
                child: CustomTextFormField(
                  label: "Verify-Password",
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
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(licentaColors.opacity | theme.colorScheme.primary.value),
                  foregroundColor: Color(licentaColors.opacity | theme.colorScheme.onPrimary.value),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Button pressed action
                },
                child: const Text('Register'),
              ),
              SizedBox(
                height: screenHeight * 0.002,
              ),
              Text(
                  style: TextStyle(color: Color(licentaColors.opacity | theme.colorScheme.onSurface.value)),
                  "Already have an account?"
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color(licentaColors.opacity | theme.colorScheme.primary.value),
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
