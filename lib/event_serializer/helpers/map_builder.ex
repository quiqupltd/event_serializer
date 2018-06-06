defmodule EventSerializer.Helpers.MapBuilder do
  @moduledoc """
  This module converts a list of tuples into a map with string keys.
  """

  @doc """
  Given a list of tuples like this

  [
    {"location",
     [
       {"user_id", 342343},
       {"recorded_at", "2018-05-10T15:45:42.228Z"},
       {"is_moving", true},
       {"uuid", "77E69F8E-8D56-410D-8D07-519EB89714E8"},
       {"battery", [{"is_charging", false}, {"level", 0.7799999713897705}]},
       {"timestamp", "2018-05-10 15:45:42.228Z"},
       {"odometer", 228272.4},
       {"extras",
        [
          {"deviceName", "Adzu2019s iPhone"},
          {"deviceBrand", "Apple"},
          {"deviceSystem", "11.2.6"},
          {"platform", "ios"},
          {"deviceId", "4DED07FF-DFC3-4FEC-87D0-A8FAF8C56EBB"},
          {"QuiqupVersion", "2.10.2"}
        ]},
       {"coords",
        [
          {"floor", "first"},
          {"altitude", 8.8},
          {"longitude", -0.1387377642096381},
          {"altitude_accuracy", 3},
          {"latitude", 51.505852569873916},
          {"speed", 6.24},
          {"heading", 327.3},
          {"accuracy", 10}
        ]},
       {"activity", [{"confidence", 100}, {"type", "in_vehicle"}]}
     ]}
   ]

   It converts to

   %{
      "location" => %{
        "activity" => %{"confidence" => 100, "type" => "in_vehicle"},
        "battery" => %{"is_charging" => false, "level" => 0.7799999713897705},
        "coords" => %{
          "accuracy" => 10,
          "altitude" => 8.8,
          "altitude_accuracy" => 3,
          "floor" => "first",
          "heading" => 327.3,
          "latitude" => 51.505852569873916,
          "longitude" => -0.1387377642096381,
          "speed" => 6.24
        },
        "extras" => %{
          "QuiqupVersion" => "2.10.2",
          "deviceBrand" => "Apple",
          "deviceId" => "4DED07FF-DFC3-4FEC-87D0-A8FAF8C56EBB",
          "deviceName" => "Adzu2019s iPhone",
          "deviceSystem" => "11.2.6",
          "platform" => "ios"
        },
        "is_moving" => true,
        "odometer" => 228272.4,
        "recorded_at" => "2018-05-10T15:45:42.228Z",
        "timestamp" => "2018-05-10 15:45:42.228Z",
        "user_id" => 342343,
        "uuid" => "77E69F8E-8D56-410D-8D07-519EB89714E8"
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
