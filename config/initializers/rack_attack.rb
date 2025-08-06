class Rack::Attack
  # 同一IPから過剰なリクエストをブロック
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?('/assets')
  end
  
  # ログイン試行回数制限
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == '/api/v1/auth/google' && req.post?
  end
end