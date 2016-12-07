require IEx

defmodule ElastaBot.Slack do 
    use Slack
    
    def handle_event(message = %{type: "message"}, slack, state) do
        # Only respond to messages to me!
        if Regex.run ~r/<@#{slack.me.id}>:?/, message.text do
          return_message = message.text 
          |> String.split()
          |> case do
            [_, "last", nos_queries , "alerts"] ->
              ElastaBot.Query.query_es(String.to_integer(nos_queries))
            [_, "list", "queries"] ->
              ElastaBot.Query.list_queries()
            [_, "run", "query", query_id] ->
              ElastaBot.Query.run_query(query_id)
            _ ->
              "didn't match"
            end

          send_message("<@#{message.user}> " <> return_message, message.channel, slack)
        end
        {:ok, state}
    end

    # Catch all message handler so we don't crash
    def handle_event(_, _, state) do
        {:ok, state}
    end
end
