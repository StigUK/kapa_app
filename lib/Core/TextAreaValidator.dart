validateTextArea(String value)
{
  if(value.length == 0)
  {
    return 'Це поле не може бути порожнім';
  }
  else return null;
}

String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
  if(RegExp(r"^\+?3?8?(0[5-9][0-9]\d{7})$").hasMatch(value))
    return null;
  else return 'Введіть корректний номер телефону в форматі +380-xx-yyy-zzzz';
}