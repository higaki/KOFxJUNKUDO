# ジュンク堂書店 KOF店 作業

## KOF の応募一覧から、グループ・ユーザ一覧を作成

```
$ k2g.rb booth.csv seminar.csv
$ k2u.rb booth.csv seminar.csv
```

`groups.tsv` と `users.tsv` ができる。


## 共有のためにフォーマット

```
$ g2g.rb
No.	グループ	ブース	セミナー	書籍紹介
1	日本NetBSDユーザーグループ	https://k-of.jp/backend/session/1236	https://k-of.jp/backend/session/1237
	:
	:
```


## 書籍募集

```
$ greet.rb
```


## 書籍登録

```
$ add.rb ISBN [ISBN ...]
```

`books.tsv` に書籍を登録

タイトル・URL は手作業で登録


## 推薦登録

`recommendations.tsv` にグループと書籍のリレーションを登録

ステージ登壇者、サイン会著者も登録


## 書籍共有

## Web 公開

```
$ tab.rb
```

## 書籍紹介、サイン会をステージ申請

企画の所有権をグループの代表に譲渡

