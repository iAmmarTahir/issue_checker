defmodule Issues.CLI do
    import Issues.TableFormatter, only: [print_table_for_columns: 2]
    @default_count 4

    @moduledoc """
    Handle the command line parsing and the dispatch to
    the various functions that end up generating a table
    of the last _n_ issues in a github project
    """

    def main(argv) do 
        argv 
            |> parse_args
            |> process
    end

    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
        |> elem(1)
        |> args_to_internal_representation
    end 

    def args_to_internal_representation([user, project, count]), do: {user, project, String.to_integer count}
    def args_to_internal_representation([user, project]), do: {user, project, @default_count}
    def args_to_internal_representation(_), do: :help

    def process(:help) do
        IO.puts """
            Usage: issues <user> <project> [count | #{@default_count}]
        """
        System.halt(0)
    end

    def process({user, project, count}) do 
        Issues.GithubIssues.fetch(user, project) 
            |> decode_response()
            |> sort_descending_order()
            |> last(count)
    end

    def last(list, count) do
        list 
        |> Enum.take(count)
        |> Enum.reverse()
        |> print_table_for_columns(["number","created_at","title"])
    end

    def decode_response({:ok, body}), do: body
    def decode_response({:error, error}) do
        IO.puts "Error fetching from Github: #{error["message"]}"
        System.halt(2)
    end

    def sort_descending_order(list) do
    list
        |> Enum.sort(fn i1, i2 -> i1["created_at"] >= i2["created_at"] end)
    end
end