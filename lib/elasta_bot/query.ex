defmodule ElastaBot.Query do
    @request File.read!("./data/request.json") 
    def query_es() do
         get_results_from_es()
         |> (fn(results) -> Poison.Parser.parse!(results.body)end).()
         |> (fn(r) -> r["hits"]["hits"] end).()
         |> Enum.reduce("", &(&2 <> "\n" <> &1["_source"]["message"]))
    end

    def get_results_from_es() do
        elastic_search_url = Application.get_env(:elasta_bot, ElastaBot.Query)[:elastic_search_url]
        body = create_body_for_es_post_request()
        HTTPotion.post elastic_search_url, [body: body,  headers: ["Content-Type": "application/json"]]
    end

    def convert_to_json(map_to_convert) do
        Poison.Encoder.encode(map_to_convert, [])
    end

    def create_body_for_es_post_request() do
        end_time =  :os.system_time(:seconds)*1000
        start_time = end_time - 24 * 60 * 60 * 1000
        query = "source: ecom-cms AND environment: production AND (_forwarder_host: magnoliapublic2 OR _forwarder_host: magnoliapublic1) "
        create_request(start_time, end_time, query, 10) 
        |> convert_to_json()
        |> to_string
    end

    def create_request(start_date, end_date, query, nos_results) do
      %{ query: %{
        filtered: %{
          query: %{
            query_string: %{
              analyze_wildcard: true,
              query: query
            }
          },
          filter: %{
            bool: %{
              must: [
                %{
                  range: %{
                    "@timestamp": %{
                      gte: start_date,
                      lte: end_date,
                      format: "epoch_millis"
                    }
                  }
                }
              ],
              must_not: []
             }
           }
          }
        },
        size: nos_results,
        sort: [
          %{
            "@timestamp": %{
              order: "desc",
              unmapped_type: "boolean"
            }
          }
        ],
        fields: [
          "*",
          "_source"
        ],
        script_fields: %{},
        fielddata_fields: [
          "@timestamp"
        ]
      }
    end

end
