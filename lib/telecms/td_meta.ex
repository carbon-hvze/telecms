defmodule Telecms.TdMeta do
  # TODO maybe move to compile time? ? need dynamic meta update?

  def init() do
    # TODO add error check, move types path to config
    {_res, root_path} = File.cwd()
    file_s = File.stream!(root_path <> "/tdlib-json-cli/td/td/generate/scheme/td_api.tl")

    {_, modules} = :application.get_key(:telecms, :modules)

    cached_types =
      modules
      |> Enum.map(fn m -> {m.__info__(:module), m.__info__(:functions)} end)
      |> Enum.filter(fn {_, fns} -> Enum.any?(fns, fn {name, _} -> name == :req_types end) end)
      |> Enum.flat_map(fn {module_name, _} -> apply(module_name, :req_types, []) end)

    r =
      Enum.map(cached_types, fn t -> ["^", t] end)
      |> Enum.join("|")
      |> Regex.compile!()

    find_types(file_s, r)
  end

  def find_types(file_s, reg) do
    # TODO use parser like yecc
    file_s
    |> Enum.reduce([], fn line, buffer ->
      case Regex.match?(reg, line) do
        true -> buffer ++ [line]
        false -> buffer
      end
    end)
    |> Enum.map(&parse_typedef/1)
    |> Map.new()
  end

  def parse_typedef(typedef) do
    [type_name | attrs] =
      String.split(typedef, "=") |> List.first() |> String.trim() |> String.split()

    attr_idx = attrs |> Enum.map(&defaults/1) |> Map.new()
    {type_name, attr_idx}
  end

  def defaults(term) do
    [attr, type] = String.split(term, ":")

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
