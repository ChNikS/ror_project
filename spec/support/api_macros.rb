module ApiMacros  
  def do_request(action, path, options = {})
    send(action, path, params: { format: :json }.merge(options))
  end
end