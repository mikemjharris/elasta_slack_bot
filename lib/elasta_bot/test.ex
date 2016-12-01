defmodule ElastaBot.Test do
        def test_function(message) do
                response =  HTTPotion.get("httpbin.org/get", query: %{page: 2})
                IO.puts response.body
                IO.puts message
                IO.puts "hello"
                
        end

end
