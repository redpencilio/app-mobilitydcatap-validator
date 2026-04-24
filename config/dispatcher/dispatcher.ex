defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  define_layers [ :static, :services, :fall_back, :not_found ]

  # Validation jobs
  get "/validation-jobs/:id", @json do
    Proxy.forward conn, [], "http://resource/validation-jobs/#{id}"
  end

  post "/validation-jobs/*path", @json do
    Proxy.forward conn, path, "http://validation-api/validation-jobs/"
  end

  # Tasks
  get "/tasks/:id", @json do
    Proxy.forward conn, [], "http://resource/tasks/#{id}"
  end

  # Validation summaries
  get "/validation-summaries/:id", @json do
    Proxy.forward conn, [], "http://resource/validation-summaries/#{id}"
  end

  get "/target-class-summaries/:id", @json do
    Proxy.forward conn, [], "http://resource/target-class-summaries/#{id}"
  end

  get "/rule-summaries/:id", @json do
    Proxy.forward conn, [], "http://resource/rule-summaries/#{id}"
  end

  # Frontend
  match "/assets/*path", @any do
    Proxy.forward conn, path, "http://frontend/assets/"
  end

  get "/*path", @html do
    Proxy.forward conn, path, "http://frontend/"
  end

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
