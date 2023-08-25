defmodule WhoIsHiring.Telegramer do
  use GenServer
  require Logger

  @doc """
    Send a message to a Telegram channel.
    To avoid sending too many messages to the telegram API, throttling is implemented by queue and timer.
  """

  @interval 500

  def start_link(_opts) do
    GenServer.start_link(
      __MODULE__,
      %{
        queue: :queue.new(),
        timer: nil,
        token: Application.get_env(:who_is_hiring, :telegramer)[:token],
        channel_id: Application.get_env(:who_is_hiring, :telegramer)[:channel_id]
      },
      name: __MODULE__
    )
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, {:send_message, message})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:send_message, message}, %{timer: nil} = state) do
    send(state.token, state.channel_id, message)

    timer = Process.send_after(self(), :process_message, @interval)

    {:noreply, %{state | timer: timer}}
  end

  def handle_cast({:send_message, message}, state) do
    {:noreply, %{state | queue: :queue.in(message, state.queue)}}
  end

  def handle_info(:process_message, state) do
    case :queue.out(state.queue) do
      {:empty, _} ->
        {:noreply, %{state | timer: nil}}

      {{:value, message}, new_queue} ->
        send(state.token, state.channel_id, message)

        timer = Process.send_after(self(), :process_message, @interval)
        {:noreply, %{state | queue: new_queue, timer: timer}}
    end
  end

  def send(nil, nil, _message), do: token_not_found()
  def send(nil, _channel_id, _message), do: token_not_found()
  def send(_token, nil, _message), do: token_not_found()

  def send(token, channel_id, message) do
    message =
      HtmlEntities.decode(message)
      |> URI.encode_www_form()
      |> String.replace("+", "%20")

    url = "https://api.telegram.org/bot#{token}/sendMessage"
    url = "#{url}?chat_id=#{channel_id}&text=#{message}"

    Logger.debug("Telegramer: sending to telegram #{message}")

    WhoIsHiring.TelegramClient.send_request(url)
  end

  def token_not_found, do: Logger.warning("Telegramer: telegram token or channel_id not found")
end
