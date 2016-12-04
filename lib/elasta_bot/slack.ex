require IEx

defmodule ElastaBot.Slack do 
    use Slack
    
    def handle_event(message = %{type: "message"}, slack, state) do
        # Only respond to messages to me!
        if Regex.run ~r/<@#{slack.me.id}>:?/, message.text do

          #TODO  this can be steamed better but it's working so gonna commit
          message.text 
          |> String.split()
          |> case do
            [_, "last", nos_queries , "alerts"] ->
              IO.puts nos_queries
              message_res = ElastaBot.Query.query_es(String.to_integer(nos_queries))
            _ ->
              message_res = "didn't match"
            end
          send_message("<@#{message.user}> " <> message_res, message.channel, slack)
        end
        {:ok, state}
    end

    # Catch all message handler so we don't crash
    def handle_event(_, _, state) do
        {:ok, state}
    end
end
