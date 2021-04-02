import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:simple_throttle_debounce/simple_throttle_debounce.dart';

const Duration loginAnimationDuration = Duration(milliseconds: 3000);
const Duration textfieldAnimationDuration = Duration(milliseconds: 200);

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  AnimationController _idAnimationController;
  AnimationController _passwordAnimationController;

  Animation<Offset> _idSlideAnimation;
  Animation<Offset> _passwordSlideAnimation;

  Animation<double> _idFadeAnimation;
  Animation<double> _passwordFadeAnimation;

  bool loading = false;
  bool login = false;

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    _idAnimationController = AnimationController(
      vsync: this,
      duration: textfieldAnimationDuration,
    );
    _passwordAnimationController = AnimationController(
      vsync: this,
      duration: textfieldAnimationDuration,
    );

    _idSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0),
    ).animate(
      CurvedAnimation(
        parent: _idAnimationController,
        curve: Curves.linear,
      ),
    );

    _passwordSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0),
    ).animate(
      CurvedAnimation(
        parent: _passwordAnimationController,
        curve: Curves.linear,
      ),
    );

    _idFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _idAnimationController,
        curve: Curves.linear,
      ),
    );

    _passwordFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _passwordAnimationController,
        curve: Curves.linear,
      ),
    );

    _idFocusNode.addListener(() {
      if (_idFocusNode.hasFocus) {
        _idAnimationController.forward();
      } else {
        if (_idController.text == "") {
          _idAnimationController.reverse();
        }
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _passwordAnimationController.forward();
      } else {
        if (_passwordController.text == "") {
          _passwordAnimationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _idAnimationController.dispose();
    _passwordAnimationController.dispose();

    _idController.dispose();
    _passwordController.dispose();

    _idFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  requestLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    await Future.delayed(
      loginAnimationDuration,
    );

    if (_idController.text != "test" || _passwordController.text != "1234") {
      setState(() {
        loading = false;
        errorMsg = "Please check ID and Password";
      });
      await Future.delayed(Duration(milliseconds: 3000), () {
        setState(() {
          errorMsg = "";
        });
      });
    } else {
      Navigator.pushReplacementNamed(
        context,
        "/loading",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          // alignment: Alignment.,
          image: AssetImage(
            "assets/images/background.jpg",
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassContainer.frostedGlass(
                blur: 6,
                height: 40,
                width: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SlideTransition(
                      position: _idSlideAnimation,
                      child: FadeTransition(
                        opacity: _idFadeAnimation,
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            "ID",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _idController,
                      focusNode: _idFocusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                  ],
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderWidth: 0,
                elevation: 4,
                shadowColor: Colors.black,
                alignment: Alignment.center,
                frostedOpacity: 0.1,
                borderRadius: BorderRadius.circular(12),
              ),
              SizedBox(
                height: 16,
              ),
              GlassContainer.frostedGlass(
                blur: 6,
                height: 40,
                width: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SlideTransition(
                      position: _passwordSlideAnimation,
                      child: FadeTransition(
                        opacity: _passwordFadeAnimation,
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      obscureText: true,
                      onEditingComplete: () => requestLogin(),
                    ),
                  ],
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderWidth: 0,
                elevation: 4,
                shadowColor: Colors.black,
                alignment: Alignment.center,
                frostedOpacity: 0.1,
                borderRadius: BorderRadius.circular(12),
              ),
              SizedBox(
                height: 48,
              ),
              Hero(
                tag: "loading",
                child: Material(
                  borderRadius: BorderRadius.circular(loading ? 40 : 12),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap:
                        loading || errorMsg != "" ? null : () => requestLogin(),
                    borderRadius: BorderRadius.circular(loading ? 40 : 12),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(loading ? 40 : 12),
                        color: errorMsg == "" ? Colors.teal : Colors.red[400],
                      ),
                      duration: Duration(
                        milliseconds: 300,
                      ),
                      height: 40,
                      width: loading ? 40 : 260,
                      child: Center(
                        child: loading
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Text(
                                errorMsg == "" ? "LOGIN" : errorMsg,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
