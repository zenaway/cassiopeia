import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

//아이디, 비밀번호 입력 기능
//로그인 기능
//hero?
//로그인 버튼 애니메이션
//

const Duration loginAnimationDuration = Duration(milliseconds: 3000);

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool loading = false;
  bool login = false;

  // @override
  // void initState() {
  //   super.initState();
  // }

  requestLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    await Future.delayed(
      loginAnimationDuration,
    );
    Navigator.pushReplacementNamed(
      context,
      "/loading",
    );
    // setState(() {
    //   loading = false;
    // });
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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ID",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.75),
                    ),
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
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.75),
                    ),
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
                  textAlign: TextAlign.center,
                  obscureText: true,
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
                  color: Colors.teal,
                  child: InkWell(
                    onTap: loading ? null : () => requestLogin(),
                    borderRadius: BorderRadius.circular(loading ? 40 : 12),
                    child: AnimatedContainer(
                      color: Colors.transparent,
                      duration: Duration(
                        milliseconds: 100,
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
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
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
