defmodule Inspecto.Schema do
  @moduledoc """
  This defines the shape of Ecto schema inspections.
  """
  alias Inspecto.Schema.Field

  @type t :: %__MODULE__{
          module: module(),
          source: String.t() | nil,
          primary_key: [atom()],
          fields: [Field.t()]
        }

  defstruct module: nil, source: nil, primary_key: [], fields: []

  defmodule Field do
    @moduledoc false
    @type t :: %__MODULE__{
            name: atom(),
            type: atom() | tuple(),
            default: any()
          }

    defstruct name: nil, type: nil, default: nil
  end

  @doc """
  Inspects the given Ecto schema module. This will return an `:invalid_module` tuple
  if the given module does not define an Ecto schema (this isn't 100% accurate, but
  it's unlikely that other modules would coincidentally define the same functions
  as an Ecto schema).

  ## Examples

      iex> Inspecto.Schema.inspect(MyApp.Schemas.MyThing)
      {:ok, %Inspecto.Schema{
        module: MyApp.Schemas.MyThing,
        source: "things",
        primary_key: [:id],
        fields: [
          %Inspecto.Schema.Field{name: :id, type: :integer, default: nil},
          %Inspecto.Schema.Field{name: :name, type: :string, default: ""},
          %Inspecto.Schema.Field{name: :created_at, type: :naive_datetime, default: nil},
        ]
      }}

      iex> Inspecto.Schema.inspect(Enum)
      {:invalid_module, Enum}
  """
  @spec inspect(module :: module()) :: {:ok, t()} | {:invalid_module, module()}
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

  @spec fieldtype(module :: module(), fieldname :: atom()) :: any()
  defp fieldtype(module, fieldname) do
    module.__changeset__()
    |> Map.get(fieldname)
    |> case do
      {:embed, %{cardinality: :many, related: related}} ->
        "ARRAY(#{stringify(related)})"

      other ->
        other
    end
  end

  defp stringify(module), do: String.trim_leading("#{module}", "Elixir.")
end
