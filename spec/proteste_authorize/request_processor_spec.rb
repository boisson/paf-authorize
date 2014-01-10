require 'spec_helper'
require 'action_pack'

describe ProtesteAuthorize::RequestProcessor do
  describe 'Valid requests' do

    it 'valid html request' do
      response = ActionDispatch::Response.new(200, {'Content-Type' => 'text/html'})
      request_processor = ProtesteAuthorize::RequestProcessor.new(response)
      request_processor.valid?.should be_true
    end

    it 'valid json request' do
      response = ActionDispatch::Response.new(200, {'Content-Type' => 'application/json'})
      request_processor = ProtesteAuthorize::RequestProcessor.new(response)
      request_processor.valid?.should be_true
    end

    # headers.has_key?('Content-Type') && (headers['Content-Type'].include?('text/html') || headers['Content-Type'].include?('application/json'))
  end
end