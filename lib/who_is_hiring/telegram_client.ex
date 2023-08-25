defmodule WhoIsHiring.TelegramClient do
  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       "https://api.telegram.org" => [size: 1]
     }}
  end

  def send_request(url) do
    {:ok, %Finch.Response{status: 200}} =
      Finch.build(:get, url)
      |> Finch.request(__MODULE__)

    :ok
  end
end
