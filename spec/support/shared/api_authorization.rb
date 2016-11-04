shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(action, path, options)
      expect(response.status).to eq 401
    end
    
    it 'returns 401 status if access_token is invalid' do
      do_request(action, path, options.merge(access_token: '12345'))
      expect(response.status).to eq 401
    end
  end
end