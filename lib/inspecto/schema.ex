defmodule Inspecto.Schema do
  @moduledoc """
  Formalized reflection data about an `Ecto` schema.
  """
  alias Inspecto.Schema.Field

  @type t :: %__MODULE__{
          module: module(),
          source: String.t() | nil,
          prefix: atom() | nil,
          primary_key: [atom()],
          fields: [Field.t()]
        }

  defstruct module: nil, source: nil, prefix: nil, primary_key: [], fields: []

  defmodule Field do
    @moduledoc """
    Contains info about a specific field.
    """
    @type t :: %__MODULE__{
            name: atom(),
            type: atom() | tuple(),
            default: any(),
            is_virtual?: boolean()
          }

    defstruct name: nil, type: nil, default: nil, is_virtual?: nil
  end

  @doc """
  Summarizes the given `Ecto` schema module as an `%Inspecto.Schema{}` struct.

  An error is returned if the given module does not define an `Ecto` schema
  (technically, this isn't 100% accurate, but it's unlikely that other modules
  would coincidentally define the same functions as an Ecto schema).

  ## Options


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
      {:error, Enum}
  """
  @spec inspect(module :: module(), opts :: Keyword.t()) :: {:ok, t()} | {:error, module()}
  def inspect(module, _opts \\ []) when is_atom(module) do
    {:ok,
     %__MODULE__{
       module: module,
       source: module.__schema__(:source),
       prefix: module.__schema__(:prefix),
       primary_key: module.__schema__(:primary_key),
       fields:
         module.__struct__()
         |> Map.from_struct()
         |> Map.delete(:__meta__)
         |> Enum.map(fn {fieldname, default} ->
           %Field{
             name: fieldname,
             type: fieldtype(module, fieldname),
             default: default,
             is_virtual?: is_virtual?(module, fieldname)
           }
         end)
     }}
  rescue
    UndefinedFunctionError -> {:error, "#{module} is not an Ecto schema"}
  end

  def inspect_field(module, fieldname, _opts \\ []) do
    %Field{
      name: fieldname,
      type: fieldtype(module, fieldname),
      default: default(module, fieldname)
    }
  end

  defp default(module, fieldname) do
    Map.get(module.__struct__(), fieldname)
  end

  defp is_virtual?(module, fieldname) do
    case module.__schema__(:virtual_type, fieldname) do
      nil -> false
      _ -> true
    end
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
