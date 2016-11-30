defmodule ElastaBot.SlackTest do
  use ExUnit.Case
  alias ElastaBot.Slack

  test "handle event always returns the state" do
        assert ElastaBot.Slack.handle_event(:a, :b, :state) == {:ok, :state}
  end

  test "message with type:message calls first handle event" do
        slack_bot_id = "test_id"
        message = %{type: "message", text: "<@" <> slack_bot_id <> ">: ping", user: "test-user", channel: "test-channel"}
        slack = %{me: %{id: slack_bot_id}}
        assert ElastaBot.Slack.handle_event(message, slack, :state) == {:ok, :x}

  end

end



