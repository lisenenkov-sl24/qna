module ApiHelpers
  def json
    @json ||= JSON.parse(response.body, symbolize_names: true)
  end

  def jsonize(obj, values)
    obj.slice(*values).symbolize_keys.transform_values &:as_json
  end

  def do_request(method, path, options = { params: with_params })
    send method, path, options
  end

  def with_params(add = access_token_params)
    (respond_to?(:params) ? params : {}).merge(add)
  end
end