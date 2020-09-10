validateTextArea(String value)
{
  if(value.length == 0)
  {
    return 'Це поле не може бути порожнім';
  }
  if(value.length > 40){
    return 'Максимум 40 символів';
  }
  return null;
}

String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
  if (value.length != 13)
    return 'Введіть корректний номер телефону';
  else
    return null;
}