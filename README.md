# SubsManager - サブスクリプション管理API

## 概要

SubsManager は個人のサブスクリプションサービスを一元管理し、最適なプランの発見と支払いスケジュールの管理を支援するRails APIアプリケーションです。

## 主な機能

- 🔐 Google OAuth 2.0 認証
- 📱 サブスクリプション管理（追加・編集・削除・一時停止）
- 📊 支払い統計とコスト分析
- 🔄 次回支払い日の自動計算
- 🏷️ カテゴリ別管理（動画配信、音楽配信、ゲームなど）
- 💡 代替プラン提案機能
- 📈 月額・年額コスト分析

## 技術仕様

- **Ruby**: 3.1.6
- **Rails**: 7.1.5 (API モード)
- **Database**: PostgreSQL
- **Authentication**: JWT + Google OAuth
- **Testing**: MiniTest
- **API Documentation**: RESTful API

## セットアップ

### 必要な環境

- Ruby 3.1.6
- PostgreSQL 12+
- Redis（キャッシュ用）

### インストール手順

1. **リポジトリのクローン**
```bash
git clone <repository-url>
cd subs_manager
```

2. **Gemのインストール**
```bash
bundle install
```

3. **環境変数の設定**
```bash
cp .env.example .env
# .envファイルを編集して必要な値を設定
```

4. **データベースの作成とマイグレーション**
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. **テストの実行**
```bash
rails test
```

6. **サーバーの起動**
```bash
rails server
```

## 環境変数

```env
# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_google_client_secret

# Database
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=
DATABASE_HOST=localhost

# Redis
REDIS_URL=redis://localhost:6379/0

# Frontend CORS
FRONTEND_URL=http://localhost:3000
```

## API エンドポイント

### 認証

```
POST   /api/v1/auth/google     # Google OAuth ログイン
GET    /api/v1/auth/me         # 現在のユーザー情報
DELETE /api/v1/auth/logout     # ログアウト
```

### ユーザー

```
GET    /api/v1/profile         # プロフィール取得
PATCH  /api/v1/profile         # プロフィール更新
```

### サブスクリプション

```
GET    /api/v1/subscriptions           # 一覧取得
POST   /api/v1/subscriptions           # 新規作成
GET    /api/v1/subscriptions/:id       # 詳細取得
PATCH  /api/v1/subscriptions/:id       # 更新
DELETE /api/v1/subscriptions/:id       # 削除
PATCH  /api/v1/subscriptions/:id/toggle_active  # 有効/無効切り替え
GET    /api/v1/subscriptions/statistics # 統計情報取得
```

### カテゴリ

```
GET    /api/v1/categories      # カテゴリ一覧
```

### 代替プラン

```
GET    /api/v1/alternative_plans              # 代替プラン一覧
GET    /api/v1/alternative_plans/by_category  # カテゴリ別代替プラン
```

## データ構造

### User（ユーザー）
- name: 名前
- email: メールアドレス
- google_id: Google ID
- avatar_url: アバター画像URL

### Subscription（サブスクリプション）
- name: サービス名
- price: 料金
- billing_cycle: 課金サイクル（monthly/yearly）
- start_date: 開始日
- payment_method: 支払い方法
- is_active: 有効フラグ
- service_url: サービスURL
- notes: メモ

### Category（カテゴリ）
- name: カテゴリ名
- color: 表示色
- icon: アイコン名

### AlternativePlan（代替プラン）
- name: プラン名
- price: 料金
- billing_cycle: 課金サイクル
- features: 機能説明
- plan_type: プランタイプ（same_company/competitor）
- company: 会社名

## テスト

```bash
# すべてのテストを実行
rails test

# モデルテストのみ
rails test test/models/

# コントローラーテストのみ  
rails test test/controllers/

# 特定のテストファイル
rails test test/models/subscription_test.rb
```

## デプロイ

### Heroku でのデプロイ例

```bash
# Heroku アプリ作成
heroku create your-app-name

# PostgreSQL アドオン追加
heroku addons:create heroku-postgresql:mini

# Redis アドオン追加  
heroku addons:create heroku-redis:mini

# 環境変数設定
heroku config:set GOOGLE_CLIENT_ID=your_client_id
heroku config:set GOOGLE_CLIENT_SECRET=your_client_secret
heroku config:set FRONTEND_URL=https://your-frontend-domain.com

# デプロイ
git push heroku main

# データベースマイグレーション
heroku run rails db:migrate
heroku run rails db:seed
```

## セキュリティ機能

- JWT トークンベース認証
- CORS 設定
- レート制限（Rack::Attack）
- セキュリティヘッダー設定
- パラメータフィルタリング

## 開発

### コードスタイル

- ファクトリーボット使用（テストデータ）
- WebMock 使用（外部API テスト）
- MiniTest レポーター使用（テスト結果表示）

### 主要なGem

- `jwt` - JWT 認証
- `google-id-token` - Google ID Token 検証
- `active_model_serializers` - JSON シリアライゼーション
- `rack-cors` - CORS 対応
- `rack-attack` - レート制限
- `secure_headers` - セキュリティヘッダー

## ライセンス

MIT License

## 貢献

1. フォークする
2. フィーチャーブランチを作成 (`git checkout -b feature/new-feature`)
3. コミット (`git commit -am 'Add new feature'`)
4. プッシュ (`git push origin feature/new-feature`)
5. プルリクエストを作成

## サポート

問題や質問がある場合は、GitHub Issues で報告してください。
