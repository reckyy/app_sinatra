### environment
ruby 3.2.2

### How to start.
1. まず、このリポジトリをcloneします。
`git clone https://github.com/reckyy/app_sinatra.git`

2. PostgreSQLをインストール
もしPostgreSQLをインストールしてなければ、[公式サイト](https://www.postgresql.jp/download)からインストールしてください。

3. テーブルの作成
`ruby pg.rb`

4. 起動してください。
`ruby main.rb`
起動したら、`http://localhost:4567`にアクセスしてください。
メモ一覧が出てくれば、アクセス成功です。

### How to use.
- 新規メモ投稿

![](/images/index.png)

画像下部の`新規メモ`をクリックすると、新規メモ投稿画面に飛びます。
titleとcontentを入力したら、下の投稿を押すと投稿されます。

- メモ詳細確認

メモ一覧の中で、詳細を見たいメモのタイトルをクリックします。

![](/images/show.png)
*画像はクリック後の画面です*

- メモ詳細編集

詳細画面で、変更をクリックします。
内容編集後、保存をクリックします。

![](/images/edit.png)

- メモ削除

詳細画面で、削除をクリックします。
「本当に削除しますか？」と確認されるので、良い場合はOKをクリックします。

![](/images/delete.png)
