# [Cal5374](http://cal5374.herokuapp.com/) [![Build Status](https://travis-ci.org/CodeforOkinawa/cal5374.svg?branch=master)](https://travis-ci.org/CodeforOkinawa/cal5374)

[5374.jp](http://5374.jp/)で提供されているゴミ収集日をカレンダーのスケジュールに変換するサービスです。

## エンドポイント

### ゴミ収集日スケジュール`.ics`ファイルダウンロード

```
GET /calendar.ics?site={YOUR_5374_WEBSITE_URL}&area={地域名} HTTP/1.1
Host: cal5374.herokuapp.com
```


### 例: [那覇市版5374](http://naha.5374.jp)の「古波蔵1〜4丁目(旧字古波蔵を含む)」地域の場合

[/calendar?site=http&#58;//naha.5374.jp&area=古波蔵1〜4丁目(旧字古波蔵を含む)](http://cal5374.herokuapp.com/calendar.ics?site=http%3A%2F%2Fnaha.5374.jp&area=%E5%8F%A4%E6%B3%A2%E8%94%B51%E3%80%9C4%E4%B8%81%E7%9B%AE%28%E6%97%A7%E5%AD%97%E5%8F%A4%E6%B3%A2%E8%94%B5%E3%82%92%E5%90%AB%E3%82%80%29)

## TODO

- [x] ゴミ収集日のスケジュールを`.ics`ファイルとしてダウンロード出来るようにする
- [ ] 分かりやすい使い方の説明を書く
- [x] 既存の5374.jpに簡単にスケジュールへリンクを貼れるようにする(具体的には1行追加するだけでリンクが貼れる)
- [ ] 5374.jpのテンプレートに取り込んでもらう
- [ ] 期間によってごみ収集日を変更するセンターに対応する
- [ ] ごみの種類ごとにカレンダーを作成できるようにする
- [ ] 誰でもデプロイ出来るようにする(Heroku向けに`app.json`を書く)

## 開発
ローカルで開発する際は以下のコマンドでサーバーを起動することが出来ます。

``` console
$ bundle install
$ bundle exec rake db:migrate
$ bundle exec rails server
```

[CodeforOkinawa/cal5374](https://github.com/CodeforOkinawa/cal5374)の`master`ブランチにpushすると[Travis CI](https://travis-ci.org/CodeforOkinawa/cal5374)で自動的にビルドされ[Cal5374](http://cal5374.herokuapp.com/)にデプロイされます。
