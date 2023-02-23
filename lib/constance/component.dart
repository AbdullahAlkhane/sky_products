import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void pushToNextScreen(context, wight) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => wight),
    );

void showToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showToastSuccess(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void navigatorAndFinish(context, Widget widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

Widget bottom({
  required double width,
  required double height,
  required Color color,
  required VoidCallback? onPressed,
  required String text,
  required Color colorText,
  required Color borderColor,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: MaterialButton(
        hoverColor: AppColors.secondColor,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 21.0,
            color: colorText,
          ),
        ),
      ),
    );

Widget customBottom({
  required double width,
  required double height,
  required Color color,
  required VoidCallback? onPressed,
  required Widget widget,
  required Color borderColor,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: MaterialButton(
          onPressed: onPressed, padding: EdgeInsets.zero, child: widget),
    );

Widget defaultEditText({
  required TextEditingController controller,
  required TextInputType keyboardType,
  Function? onFiled,
  // Function? onChanged ,
  FormFieldValidator<String>? validator,
  required String label,
  required String hint,
  IconData? prefix,
  IconData? suffix,
  suffixPressed,
  bool? obscureText = false,
  Function(String)? onSubmit,
}) =>
    TextFormField(
      onFieldSubmitted: onSubmit,
      obscureText: obscureText!,
      controller: controller,
      keyboardType: keyboardType,
      // onChanged:(s)
      // {
      //   onChanged!(s);
      // } ,
      validator: validator,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Color(0xff000df4),
        ),
        labelText: label,
        icon: Icon(
          prefix,
          color: const Color(0xff000df4),
        ),

        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11.5),
        // border: InputBorder.none,
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        //filled: false,
        //fillColor: Colors.grey[200],
      ),
    );

Widget separator(double wide, double high) {
  return SizedBox(
    width: wide,
    height: high,
  );
}

Widget buildProfileItem(IconData iconData, String title,
    {GestureTapCallback? ontab}) {
  return Column(
    children: [
      ListTile(
        onTap: ontab,
        leading: Icon(
          iconData,
          size: 32,
          color: Colors.green,
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 17.0,
              fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      const Divider(
        height: 1,
        color: Colors.grey,
      ),
    ],
  );
}

Widget defaultFormField({
  required context,
  TextEditingController? controller,
  dynamic label,
  IconData? prefix,
  String? hint,
  String? initialValue,
  TextInputType? keyboardType,
  Function(String)? onSubmit,
  onChange,
  onTap,
  required String? Function(String?) validate,
  bool isPassword = false,
  bool enabled = true,
  IconData? suffix,
  suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      textAlign: TextAlign.start,
      onFieldSubmitted: onSubmit,
      enabled: enabled,
      onChanged: onChange,

      onTap: onTap,
      validator: validate,
      //textCapitalization: TextCapitalization.words,
      //textAlignVertical: TextAlignVertical.center,
      //style: Theme.of(context).textTheme.bodyText1,
      //initialValue: initialValue,
      //textCapitalization: TextCapitalization.words,

      decoration: InputDecoration(
        isDense: true,
        hintStyle: const TextStyle(
          fontSize: 11.0,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        hintText: hint,
        fillColor: AppColors.primaryColor.withOpacity(0.7),
        filled: false,
        prefixIcon: Icon(
          prefix,
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(20)),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ))
            : null,
      ),
    );

PreferredSizeWidget customAppBar({ required String title, List<Widget> ?actions}) {
  return AppBar(
    actions: actions,
    centerTitle: true,
    backgroundColor: AppColors.primaryColor,
    shadowColor: AppColors.secondColor,
    title: Text(
      title,
    ),
    elevation: 5,
  );
}

Widget noData(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:  [
      const Center(
        child: Icon(
          Icons.no_stroller_outlined,
          size: 60.0,
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      Text(
        AppLocalizations.of(context)!.noData.toString(),
      ),
    ],
  );
}
