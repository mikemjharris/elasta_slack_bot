defmodule ElastaBot.Test do
    def test_function(message) do
        request = File.read!("./data/request.json") |> Poison.decode!()
        request_json = Poison.Encoder.encode(request, [])
        body = to_string request_json
        elastic_search_url = Application.get_env(:elasta_bot, ElastaBot.Test)[:elastic_search_url]
        results = HTTPotion.post elastic_search_url, [body: body,  ders: ["Content-Type": "application/json"]]
        results = Poison.Parser.parse!(results.body) 
        IO.puts "here"
        alert = Enum.at(results["hits"]["hits"],1)["_source"]["message"] 
    end

end
