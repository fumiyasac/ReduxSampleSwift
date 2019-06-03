# ReduxSampleSwift
[ING] SwiftでReduxとUI実装を合わせたサンプル（iOS Sample Study: Swift）

「チュートリアル → ユーザーの情報入力 → 1画面に複数の画面要素が混在する」という形のUI実装において、「アプリ表示に必要なデータの値 = アプリのUI要素の状態」として結びついている仕組みをiOSアプリでReduxアーキテクチャを実現するライブラリ「ReSwift」を利用して実現したアプリサンプルになります。

__※Swift5.x系の変更点: Enum表記を右記のように変更しています。 【×】case someActionName(): → 【○】case someActionName:__

`ReSwift.Action`で定義しているEnumにおいて引数を取らない（Reducerへ値を送る必要が特段ない）ものについては`()`が不要です。

### 実装概要

画面遷移以外の画面の要素表示に関する部分をReduxで管理することでそれぞれの状態に合わせた状態を実現するような構成を取っています。またContainerViewを利用した親子関係を持ったViewControllerがある場合でも対処できるような形にしています。

### 本サンプルの画面キャプチャ

#### 画面キャプチャその1

![capture1.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/3829331c-3153-01c9-0121-38fd28eb1c63.jpeg)

#### 画面キャプチャその2

![capture2.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/7c415c6f-9e1d-dc5e-aafd-a63737a3e9a1.jpeg)

#### 画面キャプチャその3

![capture3.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/2b8894ba-24d2-4568-a9ee-f67726d3b29e.jpeg)

### 本サンプルにおけるRedux処理の概要図と処理フロー

Reduxの処理に必要な各々の処理で行われている内容と、処理フローをまとめた図解は下記のようになります。

![whole_lifecycles.png](https://qiita-image-store.s3.amazonaws.com/0/17400/fbf1578d-630f-12da-517c-86ae476f3a0a.png)

またこのサンプルにおけるRedux関連処理部分のファイル名は下記のようになります。

![redux_files.png](https://qiita-image-store.s3.amazonaws.com/0/17400/669eb6ff-7e8b-8c97-1cf1-dba1f077da28.png)

### 利用ライブラリ一覧

+ [ReSwift](https://github.com/ReSwift/ReSwift) → ReduxのSwift実装用
+ [PromiseKit](https://github.com/mxcl/PromiseKit) → 非同期通信のハンドリング
+ [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) → JSONデータの解析をしやすくする
+ [Alamofire](https://github.com/Alamofire/Alamofire) → HTTPないしはHTTPSのネットワーク通信用
+ [AlamofireImage](https://github.com/Alamofire/AlamofireImage) → 画像URLからの非同期での画像表示とキャッシュサポート
+ [RealmSwift](https://github.com/realm/realm-cocoa/tree/master/RealmSwift) → アプリ内のデータベース
+ [CalculateCalendarLogic](https://github.com/fumiyasac/handMadeCalendarAdvance) → 日本の祝祭日の判定
+ [KYNavigationProgress](https://github.com/ykyouhei/KYNavigationProgress) → UINavigationBar直下へのProgressBar表示

※ `CalculateCalendarLogic`および`KYNavigationProgress`についてはSwift4.2でバージョン固定しています。

### その他補足事項や詳細記事に関して

特にReduxのメリットを生かしたUI実装を行なっている部分のポイントは下記の3つのケースになるかと思います。

![casestudy_examples.png](https://qiita-image-store.s3.amazonaws.com/0/17400/0cbe9856-db45-ab53-26ee-84334aea21f4.png)

このサンプル全体の詳細解説とポイントをまとめたものは下記に掲載しております。

+ (Qiita) https://qiita.com/fumiyasac@github/items/f25465a955afdcb795a2

