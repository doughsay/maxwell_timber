defmodule MaxwellTimber.Middleware do
  @moduledoc """
  Maxwell middleware for logging outgoing requests to Timber.io.

  Using this middleware will log all requests and responses using Timber.io formatting and metadata.

  ### Example usage
  ```
  defmodule MyClient do
    use Maxwell.Builder, ~w(get)a
    middleware MaxwellTimber.Middleware
  end
  ```

  ### Options

  - `:service_name` - the name of the external service (optional)
  """

  require Logger
  use Maxwell.Middleware
  alias Maxwell.Conn
  alias Timber.Events.{HTTPRequestEvent, HTTPResponseEvent}

  def call(conn, next, opts) do
    log_request(conn, opts)

    timer = Timber.start_timer()

    response = next.(conn)

    case response do
      {:error, reason, _conn} ->
        log_error(reason)

      %Conn{} = response_conn ->
        time_ms = Timber.duration_ms(timer)
        log_response(response_conn, time_ms, opts)
    end

    response
  end

  defp request_id do
    Logger.metadata()[:request_id]
  end

  defp log_request(conn, opts) do
    req_event =
      HTTPRequestEvent.new(
        direction: "outgoing",
        url: serialize_url(conn),
        method: conn.method,
        headers: conn.req_headers,
        body: conn.req_body,
        request_id: request_id(),
        service_name: opts[:service_name]
      )

    req_message = HTTPRequestEvent.message(req_event)

    Logger.info(req_message, event: req_event)
  end

  defp log_response(conn, time_ms, opts) do
    resp_event =
      HTTPResponseEvent.new(
        direction: "incoming",
        status: conn.status,
        time_ms: time_ms,
        headers: conn.resp_headers,
        body: normalize_body(conn),
        request_id: request_id(),
        service_name: opts[:service_name]
      )

    resp_message = HTTPResponseEvent.message(resp_event)

    Logger.info(resp_message, event: resp_event)
  end

  defp log_error(reason) do
    reason
    |> inspect
    |> Logger.error()
  end

  defp serialize_url(%Conn{url: url, path: path, query_string: query_string}) do
    Maxwell.Adapter.Util.url_serialize(url, path, query_string)
  end

  defp normalize_body(conn) do
    if Conn.get_resp_header(conn, "content-encoding") == "gzip" do
      "[gzipped]"
    else
      conn.resp_body
    end
  end
end
