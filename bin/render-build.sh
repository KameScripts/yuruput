#!/usr/bin/env bash
# エラーが発生したらスクリプトを即座に終了させる
set -o errexit

bundle install
# アセットのプリコンパイル（CSS/JSの圧縮など）
bundle exec rake assets:precompile
bundle exec rake assets:clean
# データベースのマイグレーション
bundle exec rake db:migrate