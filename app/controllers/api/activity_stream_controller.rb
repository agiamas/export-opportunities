require 'hawk'
require 'json'
require 'redis'

module Api
  class ActivityStreamController < ApplicationController
    def index
      # 401 if the server can't authenticate the request
      # 403 is never sent, since there is is no finer granularity for this endpoint:
      # the holder of the secret key is allowed to access the data

      # Ensure Authorization header is sent
      if !request.headers.key?('Authorization') then
        respond_to do |format|
          response.headers['Content-Type'] = 'application/json'
          error_object = {
            :message => 'Authorization header is missing'
          }
          format.json { render status: 401, json: error_object.to_json}
        end
        return
      end

      # Ensure Authorization header is correct
      check_and_save_nonce = Proc.new do |nonce|
        redis = Redis.new(url: Figaro.env.redis_url)
        key = 'activity-stream-nonce-' + nonce
        key_used = redis.get(key)
        if key_used then
          true
        else
          redis.set(key, true)
          redis.expire(key, 120)
          false
        end
      end
      credentials = {
        :id => Figaro.env.ACTIVITY_STREAM_ACCESS_KEY_ID,
        :key => Figaro.env.ACTIVITY_STREAM_SECRET_ACCESS_KEY,
        :algorithm => "sha256"
      }
      res = Hawk::Server.authenticate(
        request.headers['Authorization'],
        :method => request.method,
        :request_uri => request.original_fullpath,
        :host => request.host,
        :port => request.standard_port,
        :credentials_lookup => lambda { |id| id == credentials[:id] ? credentials : nil },
        :nonce_lookup => check_and_save_nonce,
      )
      if res != credentials then
        respond_to do |format|
          response.headers['Content-Type'] = 'application/json'
          error_object = {
            :message => res.message,
          }
          format.json { render status: 401, json: error_object.to_json}
        end
        return
      end

      contents = {}
      respond_to do |format|
        response.headers['Content-Type'] = 'application/activity+json'
        format.json { render status: 200, json: contents.to_json}
      end
    end
  end
end
