# Sinatraメモアプリ（ファイル保存編） README

## アプリケーションの起動方法

### （1）GitHubから以下のリポジトリをcloneします

- GitHubリポジトリ
  - 🔗 

#### 動作確認済み環境

- OS … macOS Big Sur 11.3.1
- Ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38)
- sinatra 2.1.0
- Webブラウザ … Google Chrome 90.0.4430.93

---

## メモアプリの使い方

## メモの新規作成

<http://localhost:4567/memos> にアクセスします。  
（メモアプリのトップページ）

![](https://i.gyazo.com/94fd5fd0c43e47b5d069fa124e9d5a72.png)

「作成ボタン」を押すとメモの新規作成画面に移りますので、「メモのタイトル」と「メモの内容」を入力し、「保存」ボタンを押してください。

![](https://i.gyazo.com/eb91af5c0c54f10fcd1618d90cdcc882.png)

- 補足
  - メモのタイトルを省略した際は「無題」が入ります
  - メモのタイトルと内容に文字数の制限はありません
  - 文字の装飾やリンクなどには対応していません🙇🏻‍♂️
    - 例 … 「`<strong>太字</strong>`」と入力した場合
      - そのまま「`<strong>太字</strong>`」と出力されます

メモを入力し、

![](https://i.gyazo.com/a189b8dc10939cff8008abccea74dac9.png)

「保存ボタン」を押すと以下のポップアップウインドウが出現しますので、内容に問題がなければ「OK」ボタンを押してください。

![](https://i.gyazo.com/cc82142c2dbfa09156670deeebcd79af.png)

### メモの保存完了

メモの保存が完了後、保存されたメモが表示されます。

![](https://i.gyazo.com/29c2555f0a70e56d82ed6d13e564141a.png)

### メモの一覧ページに戻る場合

画面先頭の「メモアプリ」を押すと、いつでも一覧ページにアクセスできます。  
（全ページ共通）

![](https://i.gyazo.com/c1ae485d84528f31369322577ebccf61.png)

### メモの並び順

メモは「作成した順」に並びます。  
（メモの編集を行っても並び順は固定されます）

![](https://i.gyazo.com/9c6162c249a728758d0cfd77fec2e796.png)

---

## メモの編集

メモの一覧から任意のメモを選択すると、

![](https://i.gyazo.com/fec9cc96c4787fefac56f27374b5120e.png)

メモの詳細ページへと移ります。

![](https://i.gyazo.com/83ed8683c1a8fa8f119c928a69e12a2e.png)

「変更」ボタンを押すとメモの編集が行えます。

![](https://i.gyazo.com/e1bc94f5762855e0fa97a9ca413d7c90.png)

最後に「保存」ボタンを押し、メモの詳細ページが表示されれば変更完了です。

![](https://i.gyazo.com/cd114941a51890ae3371d50e7d59d28c.png)

---

## メモの削除

メモの詳細ページにある「削除」ボタンを押すと削除できます。

![](https://i.gyazo.com/8e6cb669f2c2710ea673e2c00ba256e4.png)

「削除」ボタンを押すと確認メッセージが表示されますので、問題なければ「OK」ボタンを押します。

![](https://i.gyazo.com/16915b3f3818d2c98b678f2a8fcc4e52.png)

削除が完了すると、メモの一覧ページに移ります。

![](https://i.gyazo.com/e13792de3d7a73787683b776659e801d.png)

## 削除済みのメモや、存在しないページにアクセスした場合

「ページが見つかりませんでした」と表示されます。  
（全ページ共通）

![](https://i.gyazo.com/54da41ed5a505f130dbcde81f2cf02cf.png)

