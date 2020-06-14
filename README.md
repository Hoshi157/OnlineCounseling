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

### 3. 予約する
* 予約ページに移ったらカレンダーの日時を設定して右上の予約するボタンをタップします。
* 予約したらカウンセリング予約履歴から日時を確認できます。
* 予約した日時の5分前に通知がきます。

### 4. カウンセリング
* 予約した日時になったらプロフィール画面のビデオ通話ボタンかカウンセリング履歴のセルをタップしカウンセリングルームへ入室となり、カウンセリング開始となります。


## Features

### オフラインでもある程度の機能を使える
* Realmを使用して履歴画面、画像などを保存しておきオフラインでも表示できるようになっている。

### バックアップが取れる
* アプリを削除してもメールアドレス、パスワードを登録しておけばFirebaseからバックアップが取れる。

### サイドメニューを実装
* Pan, Tapに対応したスライドメニューの実装。


## Library
* MaterialComponents
* FSCalendar
* Skyway
* XLPagerTabStrip
* Snapkit
* Messagekit
* RealmSwift
* Firestore


