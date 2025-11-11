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

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    _riveArtboard?.removeController(controllerIdle);
    _riveArtboard?.removeController(controllerHandsUp);
    _riveArtboard?.removeController(controllerHandsDown);
    _riveArtboard?.removeController(controllerSuccess);
    _riveArtboard?.removeController(controllerFail);
    _riveArtboard?.removeController(controllerLookDownRight);
    _riveArtboard?.removeController(controllerLookDownLeft);
    _riveArtboard?.removeController(controllerLookIdle);
    isLookingLeft = false;
    isLookingRight = false;
    debugPrint("All controllers removed");
  }

  void addIdleController() {
    removeAllControllers();
    _riveArtboard?.addController(controllerIdle);
    debugPrint("Idle controller added");
  }

  void addHandsUpController() {
    removeAllControllers();
    _riveArtboard?.addController(controllerHandsUp);
    debugPrint("Hands up controller added");
  }

  void addHandsDownController() {
    removeAllControllers();
    _riveArtboard?.addController(controllerHandsDown);
    debugPrint("Hands down controller added");
  }

  void addSuccessController() {
    removeAllControllers();
    _riveArtboard?.addController(controllerSuccess);
    debugPrint("Success controller added");
  }

  void addFailController() {
    removeAllControllers();
    _riveArtboard?.addController(controllerFail);
    debugPrint("Fail controller added");
  }

  void addLookDownRightController() {
    removeAllControllers();
    isLookingRight = true;
    _riveArtboard?.addController(controllerLookDownRight);
    debugPrint("Look down right controller added");
  }

  void addLookDownLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    _riveArtboard?.addController(controllerLookDownLeft);
    debugPrint("Look down left controller added");
  }

  void addLookIdleController() {
    removeAllControllers();
    _riveArtboard?.addController(controllerLookIdle);
    debugPrint("Look idle controller added");
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void dispose() {
    controllerIdle.dispose();
    controllerHandsUp.dispose();
    controllerHandsDown.dispose();
    controllerSuccess.dispose();
    controllerFail.dispose();
    controllerLookDownRight.dispose();
    controllerLookDownLeft.dispose();
    controllerLookIdle.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
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

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      addSuccessController();
    } else {
      addFailController();
    }
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
        child: SingleChildScrollView(
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
                        onChanged: (value) {
                          if (value.isNotEmpty && value.length < 16 && !isLookingLeft) {
                            addLookDownLeftController();
                          } else if (value.isNotEmpty && value.length >= 16 && !isLookingRight) {
                            addLookDownRightController();
                          } else if (value.isEmpty && (isLookingLeft || isLookingRight)) {
                            addLookIdleController();
                          }
                        }),
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
                        passwordFocusNode.unfocus();
                        validateEmailAndPassword();
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
      ),
    );
  }
}
