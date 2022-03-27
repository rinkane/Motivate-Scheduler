<p align="center">
  <image src="https://user-images.githubusercontent.com/98583328/160266526-8f27affb-0bbb-456c-bb56-d927f470a499.PNG">
</p>
  
<h2 align="center">Motivate-Schedule</h2>

[![codecov](https://codecov.io/gh/rinkane/Motivate-Scheduler/branch/master/graph/badge.svg?token=JSVH9HO5F0)](https://codecov.io/gh/rinkane/Motivate-Scheduler)
[![widget-test](https://github.com/rinkane/Motivate-Scheduler/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/rinkane/Motivate-Scheduler/actions/workflows/main.yml) 

<p align="center">
  <a href="https://firebase.google.com/"><img src="https://user-images.githubusercontent.com/39142850/71645860-dd686b00-2d21-11ea-93f3-953cee4f0b32.png" height="45px;"  /></a>
  <a href="https://flutter.dev/"><img src="https://user-images.githubusercontent.com/98583328/160267750-6c2ef1b7-90ee-480f-bcb7-5ef38839a322.png" height="45px;" /></a>
</p>


## 概要
モチベーション管理に重点を置いた簡易なスケジュール管理アプリです。

## App URL
### **https://motivate-scheduler.web.app**

## 機能
### スケジュール一覧
![motivate scheduler list](https://user-images.githubusercontent.com/98583328/160268141-36bd4d9c-e097-4978-848a-652d58b2071c.PNG)

期間が重なっているスケジュールがある場合、警告を表示します。  
また、画面上部の+ボタンからスケジュールの追加、スケジュール右部の各ボタンから完了・修正・削除ができます。

### スケジュール追加
![motivate scheduler add](https://user-images.githubusercontent.com/98583328/160268304-01fbca9b-41ef-4029-b96b-b892e02ee94b.PNG)

スケジュール名、スケジュールの期間、モチベーション値を設定できます。  
モチベーション値はその予定をこなすとどのぐらいモチベーションが回復/消費するか、というのを想定しています。

### 完了したスケジュール一覧
![motivate scheduler complete](https://user-images.githubusercontent.com/98583328/160268366-71dd8a3f-a1b4-40c9-a7a2-b6205332badb.PNG)

完了したスケジュールの一覧を表示します。
完了したスケジュールに関しては削除のみ可能です。修正はスケジュールを完了するときに期間とモチベーション値のみ可能です。

### モチベーショングラフ
![motivate graph](https://user-images.githubusercontent.com/98583328/160268403-93abe461-dfd9-49e0-8c8b-0922185e6bf2.PNG)

スケジュールのモチベーション値から、いつ、どのくらいのモチベーションになるのかをグラフで表示します。  
現状試験的な機能なので、アプリを長期間使用するとデータが溜まって見辛くなってしまいます。  
その内改善するかも…。
