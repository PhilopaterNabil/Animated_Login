import 'package:animated_login/core/enum/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Artboard? _riveArtboard;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerLookIdle;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String testEmail = "ELking@email.com";
  final String testPassword = "123456";
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.Hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookIdle = SimpleAnimation(AnimationEnum.look_idle.name);

    rootBundle.load('assets/login_animation.riv').then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;

        artboard.addController(controllerIdle);
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Animated Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 3,
              child: _riveArtboard == null ? SizedBox.shrink() : Rive(artboard: _riveArtboard!),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    validator: (value) => value != testEmail ? 'Invalid email' : null,
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height / 40),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    validator: (value) => value != testPassword ? 'Invalid password' : null,
                    focusNode: passwordFocusNode,
                    obscureText: true,
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height / 40),
                  ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width / 2,
                        MediaQuery.of(context).size.height / 18,
                      ),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
