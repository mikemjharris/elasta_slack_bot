require IEx

defmodule ElastaBot.Slack do 
    use Slack
    
    def handle_event(message = %{type: "message", text: _}, slack, state) do
        # Only respond to messages to me!
        if Regex.run ~r/<@#{slack.me.id}>:?/, message.text do
          return_message = "a" 
        

          return_message = Regex.run(~r/.+\squery\s([0-9]+)\s(?<querytext>.+)/, message.text) 
          |> case do
            [_, nos, query] -> 
              ElastaBot.Query.run_string_query(query, nos)
            nil ->
               message.text
              |> String.split()
              |> case do
                [_, "last", nos_queries , "alerts"] ->
                  ElastaBot.Query.query_es(String.to_integer(nos_queries))
                [_, "list", "queries"] ->
                  ElastaBot.Query.list_queries()
                [_, "run", "query", query_id] ->
                  ElastaBot.Query.query_es(10, query_id)
                [_, "run", "query", query_id, nos_queries] ->
                  ElastaBot.Query.query_es(nos_queries, query_id)
                ["thanks", _] ->
                  thank_you_message()
                _ ->
                  "didn't match"
                end
          end

          send_message("<@#{message.user}> " <> return_message, message.channel, slack, message.ts)
        end
        {:ok, state}
    end

    def thank_you_message do
      "No problem"
    end

    # Catch all message handler so we don't crash
    def handle_event(_, _, state) do
        {:ok, state}
    end
end
