# 端末と API の境界

状態: 調査メモ（2026-09-28）。仕様の判断は [spec.md](../spec.md) にあります。ここは、その判断の根拠と、まだ測っていないことに限って書きます。

数値や可用性が公式ドキュメントと食い違ったら、公式を優先してこの文書を直します。

## 手元の端末

| 端末 | SoC | この調査時点の OS 上限 | オンデバイスの位置づけ |
| --- | --- | --- | --- |
| iPhone 8 Plus | A11 | iOS 16 系。2026-05-11 の 16.7.16 がセキュリティ更新の例。iOS 17 以降は入らない | 撮影と、アルバムの消費。美的スコア API も Apple Intelligence も無い |
| iPad mini（第 5 世代） | A12 | iPadOS 26 の対応機種に含まれる | 優先する計算ノード。Apple Intelligence の対象外 |
| Pixel 10a | 未購入のため未確認 | 未確認 | 将来の Android 実装。必須にしない |

出典:

- iPhone 8 Plus の最終メジャーは iOS 16。Apple のセキュリティリリース一覧に、iOS 16.7.16（2026-05-11、対象に iPhone 8 Plus）がある。https://support.apple.com/en-us/100100
- iPadOS 26 の対応機種に iPad mini（第 5 世代）が含まれる。https://support.apple.com/en-us/123706
- Apple Intelligence の対象は、iPhone 16 系、iPhone 15 Pro 系、A17 Pro の iPad mini、M1 以降の iPad などであり、A12 の mini 第 5 世代は含まれない。発表時の対象機種は https://www.apple.com/newsroom/2025/06/ipados-26-introduces-powerful-new-features-that-push-ipad-even-further/ の注記を参照。

A11 にも Neural Engine はあります。A12 の方が世代が新しい、という差はあります。どちらも「機械学習が全く動かない」端末ではありません。差は、新しい OS の API がインストールできるかどうかです。

## iOS のアルバム

PhotoKit のユーザアルバムは、写真ファイルの所属リストです。`PHAssetCollectionChangeRequest` でアルバムを作り、既存の `PHAsset` を足せます。元の写真はカメラロールに残ります。iCloud 写真がオンなら、この所属は同じライブラリを開く他の Apple 端末へ同期します。iPad で確定したアルバムを、iPhone のみてねから開く、という仕様の分岐はここを前提にしています。

読み書きには `PHAccessLevel.readWrite` が必要です。`.addOnly` では既存写真をアルバムへまとめられません。

限定アクセス（`PHAuthorizationStatus.limited`）では、ユーザアルバムの作成も取得もできません。WWDC20 の説明がこの制約の一次に近い記述です。https://developer.apple.com/videos/play/wwdc2020/10641/

したがって初版は、全写真へのアクセスを求めます。限定アクセスのままでは月次アルバムを作れないことを、仕様の確認画面に書きます。

### 読めるもの、読めないもの

読めるもの:

- 作成日時、修正日時、画素サイズ、メディア種別、位置情報（写真に付いていれば）。
- `PHAsset.isFavorite`、`isHidden`。
- `PHAssetMediaSubtype.photoScreenshot`、`.photoLive`。
- 連写の `burstIdentifier` と `representsBurst`。
- ユーザが作ったアルバムの所属。

読めないもの:

- 写真アプリの「人物」アルバムと、顔の名前。`PHAssetCollectionSubtype` のスマートアルバムにも、人物の列挙はありません。開発者フォーラムでも、People / Places は PhotoKit から取れない、というやりとりが続いています。https://developer.apple.com/forums/thread/688345
- 非公開の `Photos.sqlite` を開けば名前に届く、という話は Mac のライブラリ解析で知られています。iOS アプリからはサンドボックス外であり、スキーマも非公開です。仕様の非目標に入れています。

顔が「写っているか」「写りがよいか」は Vision でアプリ自身が計算します。写真アプリが既に付けた個人名は再利用できません。

共有アルバム（iCloud の共有）は、限定アクセスと同様にアプリから見えない場合があります。iCloud 共有ライブラリの写真が個人ライブラリの取得結果に含まれるかは、実装時に実機で 1 枚確認します。仕様の未決事項です。

## iOS 16 で使える画像の信号

iPhone 8 Plus が計算ノードになる場合の材料です。すべてオンデバイスです。

| 信号 | API の目安 | 使える OS |
| --- | --- | --- |
| 顔の矩形 | `VNDetectFaceRectanglesRequest` | iOS 11 以降 |
| 顔のランドマーク | `VNDetectFaceLandmarksRequest` | iOS 11 以降 |
| 顔の写り | `VNDetectFaceCaptureQualityRequest`（結果は `VNFaceObservation.faceCaptureQuality`、0〜1） | iOS 11 以降 |
| 人の矩形 | `VNDetectHumanRectanglesRequest` | iOS 13 以降 |
| 画像分類 | `VNClassifyImageRequest` | iOS 15 以降 |
| 顕著性 | `VNGenerateAttentionBasedSaliencyImageRequest` | iOS 13 以降 |
| 笑顔、閉眼 | `CIDetector` の `CIDetectorSmile` と `CIDetectorEyeBlink` | iOS 16 に含まれる古い API |

`CIDetector` は Vision より前の検出器です。笑顔と閉眼の専用確率が iOS 16 の Vision には見当たりません。精度は ML Kit や新しい Vision より劣る前提で、共有向けの補助信号にします。顔の主信号は `faceCaptureQuality` です。

ブレは API がありません。サムネイルの輝度に対するラプラシアンの分散を、Accelerate / vImage で計算します。絶対値は解像度と圧縮で動くので、月の中の分位点で使う方が、固定しきい値より安全です。手順の要点は [scoring.md](scoring.md) にあります。

露出も API がありません。輝度ヒストグラムの端への偏りで粗い判定をします。

## iPadOS 18 以降で足せる信号

`VNCalculateImageAestheticsScoresRequest` は iOS 18.0 / iPadOS 18.0 以降です。

- 結果は `VNImageAestheticsScoresObservation`。
- `overallScore` は -1〜1 で、高いほど美的に好ましい、とドキュメントされています。
- `isUtility` は、スクリーンショット、レシート、書類のように「記録ではあるが思い出ではない」画像を示す真偽値です。

参照: https://developer.apple.com/documentation/vision/vncalculateimageaestheticsscoresrequest

iPad mini 第 5 世代は iPadOS 26 を入れられるので、OS の要件はこの API を満たします。A12 で 1 枚あたり何ミリ秒かは公開されていません。次を実機で測るまで、段階 1 の完了条件には入れません。

計測の条件:

- 電源接続、低電力モードオフ。
- 長辺 512px の `CGImage` を入力にする。原寸は使わない。
- 直近の写真から 50 枚。HEIC のデコード時間と、リクエスト時間を分ける。
- 1 枚の中央値と、50 枚の合計。サーマルが落ちるならその時点の枚数も記録する。
- シミュレータでは動かない、という報告があります。計測は実機で行います。

中央値がおおよそ 200ms を大きく超える、または 50 枚の途中で明らかなサーマル制限に入る場合は、美的スコアを切って段階 1 を出します。200ms は月 1,000 枚でフォアグラウンド約 3 分強の感覚値であり、合格基準ではありません。実測のあとで仕様の待ち時間を更新します。

utility 判定が使えるときは、書類と画面の除外を分類ラベルより優先します。iOS 16 の計算ノードでは、スクリーンショットの subtype と、分類ラベルの一致（document 系がタクソノミーに含まれる場合）で代用します。ラベル文字列を仕様で固定しません。実装時に実際の identifier を見て、除外リストをコード側の定数にします。

## ショートカット

ショートカットが確実にできること:

- 時刻トリガーでアプリを開く。
- 特定のアルバムを写真アプリで開く。
- App Intent 経由で、アプリの確認画面を開く。App Intent は iOS 16 以降にあるので、iPhone 8 Plus でも起動役には使えます。

ショートカットが、この用途では担えないこと:

- iOS 16 の標準アクションには、Vision の顔品質や美的スコアをアルバム全体へ適用する処理がありません。
- iOS 26 の「Use Model」による画像の質問は、Apple Intelligence が前提です。iPad mini 第 5 世代はその対象外です。概説の例: https://wiki.beard.fm/whats-new-apple-intelligence-in-shortcuts/deep-dive-into-image-analysis-and-sorting

写真アプリ自身の「人物」「メモリー」は優秀ですが、みてねの選択画面に出るユーザアルバムへ、月の上限付きで書き出す操作は公開されていません。今回の境界面はユーザアルバムなので、採点と書き込みはアプリが持つのが短い経路です。

## Android

段階 3 の前に読み返すメモです。Pixel 10a の実機はまだありません。

### アルバムの形

MediaStore の「アルバム」は、多くのギャラリーでは同じ `BUCKET_ID` / フォルダの写真です。iOS のような、ファイルを動かさない所属リストは、端末をまたいで期待できません。

方針は仕様に書いたとおり、`Pictures/共有と印刷/YYYY-MM/` へコピーします。

- 移動は、カメラフォルダから消えるので使いません。
- シンボリックリンクは MediaStore 越しにアルバムとして安定しません。
- Google フォトのクラウドアルバムは、2025-03-31 以降、アプリが作成していない既存メディアを Library API で操作できません。`photoslibrary.readonly` などの広いスコープは閉じ、アプリ作成データ用のスコープに限られます。https://developers.google.com/photos/support/updates

同じ時期に追加された Google Photos Picker API は、利用者にクラウド上の写真を選ばせてアプリへ渡すためのものです。月次アルバムを他アプリの選択画面へ出す用途には向きません。

Google フォトアプリは、端末内フォルダを「デバイスのフォルダ」として表示することがあります。クラウドアルバムとは別の一覧です。みてねやプリントスクエアの Android 版が、システムピッカーや端末フォルダを見せるかは、段階 3 で実機確認します。iOS のように「いま手作業でできている」証拠が Android 側にはまだありません。

権限は、Android 13 以降の `READ_MEDIA_IMAGES` に相当する全写真アクセスが必要です。Android 14 以降の「一部の写真だけ」は、iOS の限定アクセスと同じで、月全体の走査とフォルダ作成の契約を満たしません。

### オンデバイスの信号

ML Kit の顔検出はオンデバイスで、個人の識別はしません。笑顔と開眼の確率、ランドマーク、輪郭が取れます。入力の顔はおおよそ 100×100px 以上が推奨です。https://developers.google.com/ml-kit/vision/face-detection

画像ラベルは標準モデルで 400 以上のラベルです。風景、料理、書類の粗い分類に使えます。https://developers.google.com/ml-kit/vision/image-labeling/android

ブレの専用 API は ML Kit に見当たりません。iOS と同じく鮮鋭度は自前です。

Gemini Nano は ML Kit GenAI Prompt API 経由で、対応端末のオンデバイスモデルとして使えます。2026-07 の Android Developers Blog では、Gemini Nano 4 のマルチモーダル（レシートからの抽出など）に触れています。https://android-developers.googleblog.com/2026/07/android-on-device-inference.html

Pixel 10a で画像入力が使えるかは、購入後の対応表で確認します。使えても初版の必須段にはしません。理由は [scoring.md](scoring.md) にあります。クラウドの Gemini API は、子どもの写真を外へ出すので使いません。

## みてねとプリントスクエア

両方とも、iOS では写真ライブラリのアルバムから選ぶ使い方を、この利用者が既にしています。仕様が依存するのはそこまでです。

調べていないこと:

- 各アプリが PhotoKit のユーザアルバムをどの画面名で出すか（「アルバム」「フォルダ」などの表記）。
- 限定アクセスを利用者が選んだ場合に、アプリ側のピッカーが空になるか。
- Android 版のピッカーが、MediaStore のフォルダを列挙するか。
- アルバムの枚数上限や、1 回の選択枚数。印刷の注文単位によって、月次アルバムの初期上限 30 が多すぎたり少なすぎたりします。

非公開 API、アクセシビリティ経由の自動操作、共有シートへの自動投稿は使いません。確定のあと人が各アプリを開く、いまの最後の一歩は残します。

## 実装前に実機で見る一覧

1. iPhone の設定で iCloud 写真がオンか。iPad の写真アプリに、直近月の写真と、iPhone で作った手作業アルバムが見えるか。
2. その手作業アルバムが、みてねとプリントスクエアの選択画面に出ることを、もう一度画面で確認する（仕様の前提の再確認）。
3. iPad mini 5 の OS が 18 以上か。美的スコア 50 枚の所要時間。
4. 段階 3 に入るとき: Android 側のピッカーが `Pictures/` 配下のフォルダを見せるか。フル解像度 30 枚のコピー容量。
