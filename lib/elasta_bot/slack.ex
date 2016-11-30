defmodule ElastaBot.Slack do 
    use Slack
    
    def handle_message(message = %{type: “message”}, slack, state) do
        if Regex.run ~r/<@#{slack.me.id}>:?\sping/, message.text do
          send_message(“<@#{message.user}> pong”,
            message.channel, slack)
        end
        {:ok, state}
    end
end