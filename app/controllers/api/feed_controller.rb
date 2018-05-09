module Api
  class FeedController < ApplicationController
    def index
      contents = \
        '<?xml version="1.0" encoding="UTF-8"?>' \
        '<feed xmlns="http://www.w3.org/2005/Atom">' \
          '<updated>' + DateTime.now.to_datetime.rfc3339 + '</updated>' \
          '<title>Export Opportunities Activity Stream</title>' \
        '</feed>'
      respond_to do |format|
        response.headers['Content-Type'] = 'application/atom+xml'
        format.xml { render status: 200, xml: contents}
      end
    end
  end
end
