require 'hawk'
require 'json'

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
