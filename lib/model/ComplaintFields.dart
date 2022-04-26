class ComplaintFields {
//validate login info
  static bool validateFields(
    String binId, String distName, String subject, String description) {
    bool checkEmpty;
    try{
    if (binId == "" || distName == "" || subject == "" || description == "") {
      checkEmpty = false;
    } else {
      checkEmpty = true;
    }}catch(error){
      print(error.toString());
    }

    return checkEmpty;
  }
}
