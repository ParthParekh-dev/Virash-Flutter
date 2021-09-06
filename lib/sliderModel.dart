// import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String desc;

  SliderModel({required this.imageAssetPath, required this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];

  slides.add(SliderModel(
      desc: 'Learn how to excel at your competitive exams',
      imageAssetPath: 'assets/intro1.png'));

  slides.add(SliderModel(
      desc: 'Get personalised help from our experienced faculty',
      imageAssetPath: 'assets/intro2.png'));

  slides.add(SliderModel(
      desc: 'Put your preparation at test from various MCQ and Test series',
      imageAssetPath: 'assets/intro3.png'));

  return slides;
}
