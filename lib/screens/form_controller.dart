import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mcassets/assets_list.dart';

class FormController {
  Widget responseCustomWidget(String value, String attributes, String hintText,
      [String? initialValue, List<String>? choices,int? max,FocusNode? focusNode,]) {
    switch (value) {
      case 'form':
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Color(Assetslist.assetColors["text_color"]))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    onTap: () {},
                    autofocus: false,
                    name: attributes,
                    initialValue: initialValue ?? '',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    showCursor: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xA3898A8D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'email':
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Color(Assetslist.assetColors["text_color"]))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    autofocus: false,
                    name: attributes,
                    initialValue: initialValue ?? "",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    showCursor: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xA3898A8D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'formNo':
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Color(Assetslist.assetColors["text_color"]))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: attributes,
                    initialValue: initialValue ?? '',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    showCursor: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xA3898A8D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'number':
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Color(Assetslist.assetColors["text_color"]))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    focusNode: focusNode,
                    name: attributes,
                    initialValue: initialValue ?? '',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    validator:max !=null ? FormBuilderValidators.compose([
                      FormBuilderValidators.max(max),
                      FormBuilderValidators.required(),
                    ]):FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    showCursor: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xA3898A8D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'phoneNumber':
        return   FormBuilderField(
          name: attributes,
          builder: (FormFieldState<dynamic> field) {
            return IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'KE',
              onChanged: (phone) {
                if(phone.isValidNumber()){
                  if(phone.countryCode == '+254'){
                    field.didChange('${phone.countryCode}${phone.number.substring(1)}');
                  }
                  field.didChange(phone.completeNumber);
                }
              },
              validator: (value) {
                if (value == null || value.completeNumber.isEmpty) {
                  return 'Phone number is required';
                }
                if (!value.isValidNumber()) {
                  return 'Invalid phone number for the selected country';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            );
          },
        );
      case 'description':
        return Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Color(Assetslist.assetColors["text_color"]))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: attributes,
                    initialValue: initialValue ?? '',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    showCursor: true,
                    enableSuggestions: true,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xA3898A8D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'list':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(Assetslist.assetColors["text_color"]),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: FormBuilderDropdown(
              name: attributes,
              initialValue: initialValue ?? '',
              alignment: Alignment.center,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 75.0),
                border: InputBorder.none,
                hintText: 'select',
                hintStyle: const TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xA3898A8D),

                  fontWeight: FontWeight.w400,
                ),


              ),
              items: choices != null
                  ? choices
                  .map((choice) => DropdownMenuItem(

                value: choice,
                child: Text(choice),
              ))
                  .toList()
                  : [],
            ),
          ),
        );
      case 'password':
        RxBool showPassword = true.obs;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(Assetslist.assetColors["text_color"]),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                        () => FormBuilderTextField(
                      onTap: () {},
                      autofocus: false,
                      name: attributes,
                      initialValue: initialValue ?? '',
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(8),
                      ]),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      showCursor: true,
                      enableSuggestions: true,
                      obscureText: showPassword.value,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        // Adjust this value as needed
                        suffixIcon: GestureDetector(
                          child: Icon(
                            showPassword.value == false
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                            color: Color(Assetslist.assetColors["text_color"]),
                          ),
                          onTap: () {
                            showPassword.toggle();
                          },
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xA3898A8D),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }
}
