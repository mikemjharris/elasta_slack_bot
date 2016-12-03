defmodule ElastaBot.Query do
    @request File.read!("./data/request.json") 
    def query_es() do
        results = get_results_from_es()
        results = Poison.Parser.parse!(results.body) 
        alert = Enum.at(results["hits"]["hits"],1)["_source"]["message"] <> Enum.at(results["hits"]["hits"],2)["_source"]["message"] 
    end

    def get_results_from_es() do
        elastic_search_url = Application.get_env(:elasta_bot, ElastaBot.Query)[:elastic_search_url]
        
        create_body_for_es_post_request()
        |> (fn(body) -> HTTPotion.post elastic_search_url, [body: body,  headers: ["Content-Type": "application/json"]] end).()
    end

    def convert_to_json(map_to_convert) do
        Poison.Encoder.encode(map_to_convert, [])
    end

    def create_body_for_es_post_request() do
        Poison.decode!(@request)
        |> convert_to_json()
        |> to_string
    end

end
