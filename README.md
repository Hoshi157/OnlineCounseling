# OnlineCounseling
* このアプリはカウンセラーとビデオ通話機能にてオンラインでカウンセリングができるアプリケーションです。


## アプリ使用の流れ

### 1. アカウントを登録する
* プロフィールを作成し自分のアカウントを作成します。
  
  <img src="https://user-images.githubusercontent.com/51669998/84586805-5b927700-ae55-11ea-9030-0ea32b88f83e.gif" width="200px">&emsp;

### 2. カウンセラーを探す
* ホーム画面のセルをタップするとカウンセラーのプロフィール画面が見れます。
* カレンダーのボタンをタップして予約ページに移ります。
* ビデオ通話ボタンを押すとビデオ通話、メッセージボタンを押すとテキストチャットができます。
  
  <img src="https://user-images.githubusercontent.com/51669998/84588895-1165c180-ae66-11ea-9a86-edc520a43d09.gif" width="200px">&emsp;

### 3. 予約する
* 予約ページに移ったらカレンダーの日時を設定して右上の予約するボタンをタップします。
* 予約したらカウンセリング予約履歴から日時を確認できます。
* 予約した日時の5分前に通知がきます。
  
  <img src="https://user-images.githubusercontent.com/51669998/84589049-09f2e800-ae67-11ea-9ec3-b10e5ce076fc.gif" width="200px">&emsp;
  <img src="https://user-images.githubusercontent.com/51669998/84589334-bb464d80-ae68-11ea-9253-70793b9b0dfc.gif" width="200px">&emsp;

### 4. カウンセリング
* 予約した日時になったらプロフィール画面のビデオ通話ボタンかカウンセリング履歴のセルをタップしカウンセリングルームへ入室となり、カウンセリング開始となります。
  
  <img src="https://user-images.githubusercontent.com/51669998/84589401-33ad0e80-ae69-11ea-8ca4-a7ad95489b69.gif" width="200px">&emsp;


## Features

### オフラインでもある程度の機能を使える
* Realmを使用して履歴画面、画像などを保存しておきオフラインでも表示できるようになっている。

### バックアップが取れる
* アプリを削除してもメールアドレス、パスワードを登録しておけばFirebaseからバックアップが取れる。

### サイドメニューを実装
* Pan, Tapに対応したスライドメニューの実装。
  
  <img src="https://user-images.githubusercontent.com/51669998/84589528-0c0a7600-ae6a-11ea-8e97-01d29c430c13.gif" width="200px">&emsp;


## Library
* MaterialComponents
* FSCalendar
* Skyway
* XLPagerTabStrip
* Snapkit
* Messagekit
* RealmSwift
* Firestore


