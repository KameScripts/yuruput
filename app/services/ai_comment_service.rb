# app/services/ai_comment_service.rb
require 'net/http'
require 'json'
require 'uri'

class AiCommentService
  # クラスを呼び出すときに投稿内容（post_body）を受け取る
  def initialize(post_body)
    @post_body = post_body
    @api_key = ENV["GEMINI_API_KEY"]
  end

  # 実際にAPIを叩くメソッド
  def call
    uri = URI("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{@api_key}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # 渡された投稿内容（@post_body）を使ってプロンプトを組み立てる
    prompt_text = "以下の入力内容に対して、励ますような言葉を一文と、さらに良くするためのアドバイスを一文ください。\n\n入力内容：#{@post_body}"

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = {
      contents: [{ parts: [{ text: prompt_text }] }]
    }.to_json

    response = http.request(request)
    json = JSON.parse(response.body)

    if json["error"]
      Rails.logger.error("Gemini API Error: #{json.dig('error', 'message')}")
      return "AIからのフィードバック取得に失敗しました。" # エラー時のフォールバック
    else
      return json.dig("candidates", 0, "content", "parts", 0, "text")
    end
  rescue => e
    Rails.logger.error("Gemini API Exception: #{e.message}")
    return "AIからのフィードバック取得に失敗しました。"
  end
end