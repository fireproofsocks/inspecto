defmodule Inspecto.Schema do
  @moduledoc """
  This defines the shape of schema inspections
  """
  defstruct module: nil, source: nil, primary_key: [], fields: []

  defmodule Field do
    @moduledoc false
    defstruct name: nil, type: nil, default: nil
  end

  @doc """
  Inspects the given Ecto schema module. This will raise if the given module does not
  define an Ecto schema (this isn't 100% accurate, but it's unlikely that other modules
  would coincidentally define the same functions as an Ecto schema).
  """
  def inspect(module) when is_atom(module) do
    {:ok,
     %__MODULE__{
       module: module,
       source: module.__schema__(:source),
       primary_key: module.__schema__(:primary_key),
       fields:
         module.__struct__()
         |> Map.from_struct()
         |> Map.delete(:__meta__)
         |> Enum.map(fn {fieldname, default} ->
           %Field{name: fieldname, type: fieldtype(module, fieldname), default: default}
         end)
     }}
  rescue
    UndefinedFunctionError -> {:invalid_module, module}
  end

  defp fieldtype(module, fieldname) do
    module.__changeset__()
    |> Map.get(fieldname)
    |> case do
      {:embed, %Ecto.Embedded{cardinality: :many, related: related}} ->
        "ARRAY(#{stringify(related)})"

      other ->
        other
    end
  end

  defp stringify(module), do: String.trim_leading("#{module}", "Elixir.")
end
