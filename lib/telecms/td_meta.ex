defmodule Telecms.TdMeta do
  import Enum, only: [map: 2, filter: 2, reduce: 3, any?: 2, flat_map: 2]
  import String, only: [split: 2, trim: 1, split: 1]
  import List, only: [first: 1]

  def init() do
    # TODO add error check, move types path to config
    {_res, root_path} = File.cwd()
    file_s = File.stream!(root_path <> "/tdlib-json-cli/td/td/generate/scheme/td_api.tl")

    {_, modules} = :application.get_key(:telecms, :modules)

    cached_types =
      modules
      |> map(fn m -> {m.__info__(:module), m.__info__(:functions)} end)
      |> filter(fn {_, fns} -> any?(fns, fn {name, _} -> name == :req_types end) end)
    |> flat_map(fn {module_name, _} -> apply(module_name, :req_types, []) end)

    r =
      map(cached_types, fn t -> ["^", t] end)
      |> Enum.join("|")
      |> Regex.compile!()

    find_types(file_s, r)
  end

  def find_types(file_s, reg) do
    # TODO use parser like yecc
    file_s
    |> reduce([], fn line, buffer ->
      case Regex.match?(reg, line) do
        true -> buffer ++ [line]
        false -> buffer
      end
    end)
    |> map(&parse_typedef/1)
    |> Map.new()
  end

  def parse_typedef(typedef) do
    [type_name | attrs] = split(typedef, "=") |> first |> trim |> split
    attr_idx = attrs |> map(&defaults/1) |> Map.new()
    {type_name, attr_idx}
  end

  def defaults(term) do
    [attr, type] = split(term, ":")

    init_val =
      case type do
        "Bool" -> false
        "string" -> ""
        "int32" -> 0
        _ -> :unknown
      end

    {attr, init_val}
  end
end
