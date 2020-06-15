import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io';
import 'package:prototype_cashier/main.dart';


class LoadingPreview extends StatelessWidget {
  int state;
  LoadingPreview({int state}) {
    this.state=state;
    whichState();
  }

  void whichState(){
      if(state==0){
        this.text='Идет подсчет введенных вами товаров\n\n Пожалуйста, подождите ;)';
        this.bgcolor=Colors.white70.withOpacity(0.6);
      } else if(state==1){
        this.text='Оплата произведена успешно\n\n Спасибо за покупку!)';
        this.bgcolor=Colors.green.withOpacity(0.6);
      }
      else{
        this.text='Ошибка транзакции!\n\n Недостаточно средств для оплаты!';
        this.bgcolor=Colors.red.withOpacity(0.6);
      }}
  String text;
  Color bgcolor;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=>HomePage()),
          );
        },
        child: Container(
          height: _height,
          width: _width,
            decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.85), BlendMode.dstATop),
                  image: AssetImage('assets/img/bg1.jpg'),
                  fit: BoxFit.cover,
                )
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 2,),
              AutoSizeText('PAY BY AIR',
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: 30,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),),
              Spacer(),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgcolor,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: AutoSizeText(text,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  minFontSize: 25,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w800,
                  ),),
              ),
              Spacer(),
            ],
          )
        ),
      ),
    );
  }
}
