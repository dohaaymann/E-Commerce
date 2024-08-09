import 'package:flutter/material.dart';

class fields extends ChangeNotifier{
  var semail =false;
  var spass = false,ph;

  ch_Fsemail() {
    semail = false;
    notifyListeners();
  }
  ch_Tsemail() {
    semail =true;
    notifyListeners();
  }

  ch_Tspass() {
    spass = true;
    notifyListeners();
  }

  ch_Fspass() {
    spass = false;
    notifyListeners();
  }
}


class Bool extends ChangeNotifier{
  var b=true;
  var email,pass,phone,obscure=false;
  var ver_ph,T_error=false,ver;
  var counter=1,time=false,load=false,ph;
  var internet=false;
  List list_home=[];
  List list_cata=[];
  List list_Fav=[];
  list_ch_home(var x,var v) {
   list_home[x]=v;
    notifyListeners();
  }list_ch_cata(var x,var v) {
   list_cata[x]=v;
    notifyListeners();
  }list_ch_fav(var x,var v) {
   list_Fav[x]=v;
    notifyListeners();
  }
  ch_ph(var x) {
    ph=x;
    notifyListeners();
  }
  ch_obscure(){
    obscure=!obscure;
    notifyListeners();
  }ch_T_time(){
    time=true;
    notifyListeners();
  }ch_F_time(){
    time=false;
    notifyListeners();
  }ch_T_inter(){
    internet=true;
    notifyListeners();
  }ch_F_inter(){
    internet=false;
    notifyListeners();
  }ch_T_load(){
    load=true;
    notifyListeners();
  }ch_F_load(){
    load=false;
    notifyListeners();
  } ch_ver1(var x){
    ver=x;
    notifyListeners();
  } ch_email(var x){
    email=x;
    notifyListeners();
  } ch_T_error(){
   T_error=true;
    notifyListeners();
  } ch_F_error(){
   T_error=true;
    notifyListeners();
  }ch_ver(var x){
    ver_ph=x;
    notifyListeners();
  } ch_pass(var x){
    pass=x;
    notifyListeners();
  }ch_phone(var x){
    phone=x;
    notifyListeners();
  }
  ch_bT(){
    b=true;
    notifyListeners();
  }
  add_cnt(){
    counter++;
    notifyListeners();
  } sub_cnt(){
    counter--;
    notifyListeners();
  }
  ch_bF(){
     b=false;
    notifyListeners();
  }
  var Ib=false;
  ch_Ib(){
    Ib=!Ib;
    notifyListeners();
  }
}