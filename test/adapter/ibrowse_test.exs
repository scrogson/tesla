defmodule IbrowseTest do
  use ExUnit.Case

  defmodule Client do
    use Tesla.Builder

    adapter Tesla.Adapter.Ibrowse
  end

  Tesla.Adapter.Ibrowse.start

  test "async requests" do
    {:ok, id} = Client.get("http://httpbin.org/ip", respond_to: self)

    assert_receive {:tesla_response, _}, 2000
  end

  test "async requests parameters" do
    {:ok, id} = Client.get("http://httpbin.org/ip", respond_to: self)

    receive do
      {:tesla_response, res} ->
        assert res.status == 200
    after
      2000 -> raise "Timeout"
    end
  end

end
