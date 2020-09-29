class Regmodel
{
  String name;
  String email;
  String password;
  String phoneNo;
  String addresss;
  String city;
  String state;
  Regmodel(this.name,this.email,this.password,this.phoneNo,this.addresss,this.city,this.state);

  String getstate()
  {
    return this.state;
  }
  String getname()
  {
    return this.name;
  }
  String getemail()
  {
    return this.email;
  }
  String getpassword()
  {
    return this.password;
  }
  String getphoneno()
  {
    return this.phoneNo;
  }
  String getaddress()
  {
    return this.addresss;
  }
  String getcity()
  {
    return this.city;
  }
}