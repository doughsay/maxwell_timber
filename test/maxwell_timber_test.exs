defmodule MaxwellTimberTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  doctest MaxwellTimber

  setup do
    conn = %Maxwell.Conn{
      url: "http://example.com",
      status: 200,
      method: :get
    }

    success = fn(c) -> c end
    fail = fn(c) -> {:error, "error!", c} end

    %{conn: conn, success: success, fail: fail}
  end

  test "logs requests with a timber event", %{conn: conn, success: success} do
    fun = fn ->
      MaxwellTimber.Middleware.call(conn, success, [])
    end

    assert capture_log(fun) =~ "Outgoing HTTP request to nil [GET]"
    assert capture_log(fun) =~ "Outgoing HTTP response from nil 200"
  end

  test "logs errors with a timber event", %{conn: conn, fail: fail} do
    fun = fn ->
      MaxwellTimber.Middleware.call(conn, fail, [])
    end

    assert capture_log(fun) =~ "Outgoing HTTP request to nil [GET]"
    assert capture_log(fun) =~ "error!"
  end
end
