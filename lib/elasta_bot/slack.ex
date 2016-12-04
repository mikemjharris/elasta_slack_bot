defmodule ElastaBot.Slack do 
    use Slack
    
    def handle_event(message = %{type: "message"}, slack, state) do
        # Only respond to messages to me!
        if Regex.run ~r/<@#{slack.me.id}>:?/, message.text do
          message_res = ElastaBot.Query.query_es()
         
         send_message("<@#{message.user}> " <> message_res, message.channel, slack)
        end
        {:ok, state}
    end

    # Catch all message handler so we don't crash
    def handle_event(_, _, state) do
        {:ok, state}
    end
end
