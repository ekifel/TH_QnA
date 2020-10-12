shared_examples_for 'API Destroy resource' do
  it 'return 200 status' do
    do_request(method, api_path, params: { id: resource, access_token: access_token.token }, headers: headers)
    expect(response).to be_successful
  end

  it 'resource removed from database' do
    expect { do_request(method, api_path, params: { id: resource, access_token: access_token.token }, headers: headers) }.to change(resource, :count).by(-1)
  end
end
