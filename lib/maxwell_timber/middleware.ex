defmodule MaxwellTimber.Middleware do
  require Logger
  use Maxwell.Middleware
  alias Maxwell.Conn

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
    Logger.metadata[:request_id]
  end

  defp log_request(conn, opts) do
    {req_event, req_message} =
      Timber.Events.HTTPClientRequestEvent.new_with_message(
        url: serialize_url(conn),
        method: conn.method,
        headers: conn.req_headers,
        body: conn.req_body,
        request_id: request_id(),
        service_name: opts[:service_name]
      )

    Logger.info(req_message, event: req_event)
  end

  defp log_response(conn, time_ms, opts) do
    {resp_event, resp_message} =
      Timber.Events.HTTPClientResponseEvent.new_with_message(
        status: conn.status,
        time_ms: time_ms,
        headers: conn.resp_headers,
        body: normalize_body(conn),
        request_id: request_id(),
        service_name: opts[:service_name]
      )
    Logger.info(resp_message, event: resp_event)
  end

  defp log_error(reason) do
    reason
    |> inspect
    |> Logger.error
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
