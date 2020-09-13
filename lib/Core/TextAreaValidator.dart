validateTextArea(String value)
{
  if(value.length == 0)
  {
    return 'Це поле не може бути порожнім';
  }
  if(value.length > 40){
    return 'Максимум 40 символів';
  }
  return RegExp(r"^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*$").hasMatch(value) ? null : "Введіть корректне значення";
}

String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
  if (value.length != 13)
    return 'Введіть корректний номер телефону';
  else
    return RegExp(r"^\+?3?8?(0[5-9][0-9]\d{7})").hasMatch(value) ? null : "Введіть корректний номер телефону";
}

validateOTPCode(String value){
  if(value.length != 6)
      return "Код має містити 6 цифр";
  else return RegExp(r"^[0-9]*$").hasMatch(value) ? null : "Введіть коректний код";
}