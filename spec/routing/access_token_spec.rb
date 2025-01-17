require 'rails_helper'

describe 'access tokens routes' do
  it 'should route to access_tokens create actions' do
    expect(post '/login').to route_to('access_tokens#create')
  end

  it 'should route to access_tokens destroy action' do
    expect(delete '/logout').to route_to('access_tokens#destroy')
  end
end