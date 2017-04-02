defmodule MaxwellTimber.Middleware do
  require Logger
  use Maxwell.Middleware

  def call(conn, next, _) do
    log_request(conn)

    timer = Timber.Timer.start()

    response = next.(conn)

    case response do
      {:error, reason, _conn} ->
        log_error(reason)
      %Maxwell.Conn{} = response_conn ->
        time_ms = Timber.duration_ms(timer)
        log_response(response_conn, time_ms)
    end

    response
  end

  defp log_request(conn) do
    %URI{host: host, scheme: scheme} = URI.parse(conn.url)

    {req_event, req_message} =
      Timber.Events.HTTPClientRequestEvent.new_with_message(
        host: host,
        method: conn.method,
        path: conn.path,
        scheme: scheme,
        headers: conn.req_headers,
        body: conn.req_body,
        request_id: conn.req_headers["x-request-id"]
      )

    Logger.info(req_message, event: req_event)
  end

  defp log_response(conn, time_ms) do
    {resp_event, resp_message} =
      Timber.Events.HTTPClientResponseEvent.new_with_message(
        status: conn.status,
        time_ms: time_ms,
        headers: conn.resp_headers,
        body: conn.resp_body,
        request_id: conn.req_headers["x-request-id"]
      )
    Logger.info(resp_message, event: resp_event)
  end

  defp log_error(exception) do
    message = inspect(exception)
    {:ok, event} = Timber.Events.ExceptionEvent.new(message)
    Logger.error(message, event: event)
  end
end
