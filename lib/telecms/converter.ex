defmodule Telecms.Converter do
  import String, only: [split: 2, trim: 1, split: 1]
  import List, only: [first: 1]

  def defaults(term) do
    [attr, type] = split(term, ":")

    init_val =
      case type do
        "Bool" -> false
        "string" -> ""
        "int32" -> 0
      end
    {attr, init_val}
  end

  def class_to_map(name) do
    # TODO add error check
    {_res, root_path} = File.cwd()

    path = root_path <> "/tdlib-json-cli/td/td/generate/scheme/td_api.tl"

    r = Regex.compile!(name)

    file_s = File.stream!(path)

    [_ | attrs] =
      file_s
      |> Enum.reduce_while("", fn line, buffer ->
        case Regex.match?(r, line) do
          true -> {:halt, line}
          false -> {:cont, buffer}
        end
      end)
      |> split("=")
      |> first()
      |> trim()
      |> split

      Enum.map(attrs, &defaults/1) |> Map.new() |> IO.inspect()
  end
end
