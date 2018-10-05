defmodule EventSerializer.Helpers.MapBuilder do
  @moduledoc """
  This module converts a list of tuples into a map with string keys.
  """

  @doc """
  Given a list of tuples like this

  [
    {"location",
     [
       {"user_id", 342343}
     ]
   ]

   It converts to

   %{
      "location" => %{
        "user_id" => 342343
      }
    }
  """
  def to_map(list) when is_list(list) and length(list) > 0 do
    case list |> List.first() do
      {_, _} ->
        Enum.reduce(list, %{}, fn tuple, acc ->
          {key, value} = tuple
          Map.put(acc, key, to_map(value))
        end)

      _ ->
        list
    end
  end

  def to_map(tuple) when is_tuple(tuple) do
    {key, value} = tuple
    Enum.into([{key, to_map(value)}], %{})
  end

  def to_map(value), do: value
end
