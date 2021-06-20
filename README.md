# Sinatraメモアプリ（PostgreSQL編） README

---

## 【はじめに】このアプリケーションについて

SinatraとWebブラウザを用いた簡易メモアプリケーションです。  
メモの保存には「PostgreSQL」を使用しています。

![](https://i.gyazo.com/188f07aa7786ed31b098459ea99a607f.png)

以下の環境で開発・動作確認を行いました。

- OS … macOS Big Sur 11.4
- Ruby … 3.0.1p64 (2021-04-05 revision 0fb782ee38)
- PostgreSQL … 13.3
- Webブラウザ … Google Chrome 91.0.4472.101

---

## アプリケーションの入手

任意のディレクトリで以下のGitHubリポジトリをcloneした後、リポジトリのルートディレクトリへ移動して`bundle`を実行してください。

```bash
% git clone https://github.com/fukindesu/sinatra-memo.git

% cd sinatra-memo

% bundle
```

## PostgreSQLの設定

psqlコマンドを用いて、以下のデータベースとテーブルを作成してください。  
（該当のアプリケーションコードを書き換えていただくことで、任意のデータベース名とテーブル名への変更も可能です）

```sql
-- データベース `sinatra_memo` を作成
create database sinatra_memo;
```

```bash
# データベース `sinatra_memo` に接続
\c sinatra_memo
```

```sql
-- テーブル `memos` を作成
create table memos
(
  id char(36) primary key,
  title varchar(1000),
  body varchar(10000),
  created_at timestamp default current_timestamp
);
```

```bash
# psqlを終了
\q
```

## アプリケーションの起動

ルートディレクトリに配置されている`main.rb`をrubyコマンドで実行します。

```bash
% ruby main.rb
```

実行後、Webサーバ「WEBrick」が起動し、以下のような画面状態となりますので、

![](https://i.gyazo.com/b9b11b499da93f3428bc474cd8ca2c1b.png)

この状態で、ご利用のブラウザより「メモアプリ トップページ <http://localhost:4567/memos> 」にアクセスできれば起動完了です。

![](https://i.gyazo.com/6ce343b954086f71bb0784f3bc79be37.png)

---

# メモアプリの使い方

## メモの新規作成

![](https://i.gyazo.com/94fd5fd0c43e47b5d069fa124e9d5a72.png)

「作成ボタン」を押すとメモの新規作成画面に移りますので、「メモのタイトル」と「メモの内容」を入力し、「保存」ボタンを押してください。

![](https://i.gyazo.com/eb91af5c0c54f10fcd1618d90cdcc882.png)

- 入力時のご留意事項
  - メモのタイトルを省略した際は「無題」が入ります
  - 入力可能な文字数は以下の通りです
    - メモのタイトル … 1,000文字まで（`varchar(1000)`）
    - メモの内容 … 10,000文字まで（`varchar(10000)`）
  - メモの内容は改行が可能です
  - 文字の装飾やリンクなどには対応していません🙇🏻‍♂️
    - 例 … 「`<strong>太字</strong>`」と入力した場合
      - そのまま「`<strong>太字</strong>`」と出力されます

![](https://i.gyazo.com/a189b8dc10939cff8008abccea74dac9.png)

メモを入力後、「保存ボタン」を押すと以下のポップアップウインドウが出現しますので、内容に問題がなければ「OK」ボタンを押してください。

![](https://i.gyazo.com/cc82142c2dbfa09156670deeebcd79af.png)

メモの保存完了後、保存されたメモが表示されます。

![](https://i.gyazo.com/29c2555f0a70e56d82ed6d13e564141a.png)

なお、画面先頭の「メモアプリ」はトップページ（メモの一覧）にアクセスするためのテキストリンクとなっています。  
（全ページ共通）

![](https://i.gyazo.com/c1ae485d84528f31369322577ebccf61.png)

### 【補足】メモの並び順

メモは「作成した順」に並びます。  
（メモの編集を行っても並び順は固定されたままとなります）

![](https://i.gyazo.com/9c6162c249a728758d0cfd77fec2e796.png)

---

## メモの変更

メモの一覧から任意のメモを選択し、

![](https://i.gyazo.com/fec9cc96c4787fefac56f27374b5120e.png)

メモの詳細ページへと移った後、

![](https://i.gyazo.com/83ed8683c1a8fa8f119c928a69e12a2e.png)

「変更」ボタンを押すとメモの変更ページへと移ります。

任意の内容に変更した後、

![](https://i.gyazo.com/e1bc94f5762855e0fa97a9ca413d7c90.png)

「保存」ボタンを押し、メモの詳細ページが表示されれば変更完了です。



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

---

（README ここまで）
