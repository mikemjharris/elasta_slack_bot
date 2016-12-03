defmodule ElastaBot.Slack do 
    use Slack
    
    def handle_event(message = %{type: "message"}, slack, state) do
        message_res = ElastaBot.Query.query_es()
        if Regex.run ~r/<@#{slack.me.id}>:?\sping/, message.text do
          IO.puts "here"
          send_message("<@#{message.user}> pong",
            message.channel, slack)
        end
        send_message("<@#{message.user}> " <> message_res,
            message.channel, slack)
        {:ok, state}
    end

    # Catch all message handler so we don't crash
    def handle_event(_, _, state) do
        {:ok, state}
    end
end
