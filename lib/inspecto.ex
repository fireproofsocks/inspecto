defmodule Inspecto do
  @moduledoc """
  `Inspecto` is a utility for inspecting Ecto schemas to view their field names,
  data types, and default values.

  Ecto schema modules do not contain full information about your database
  schemas: they only contain enough information to act as a viable intermediary
  for the Elixir layer.  You cannot, for example, know character length limits or
  input constraints by merely inspecting Ecto schemas.  Although Ecto _migrations_
  contain a lot more of this information, they too aren't great for the purpose
  because migrations are additive with changes spread out over time, and importantly,
  there's not requirement that a database be defined via migrations.

  ## Usage

  The expected usage of this package is to call `Inspecto.summarize/2` from within
  a `@moduledoc` tag somewhere inside your app, wherever you wish a summary of
  your Ecto schemas to appear, e.g. something like this:

  ```
  defmodule MyApp.MyModel do
    @moduledoc \"\"\"
    Here is a summary of my Ecto schemas:

    \#\{ MyApp.MyModel |> Inspecto.modules() |> Inspecto.summarize(format: :html)\}
    \"\"\"
  end
  ```

  This will render a series of HTML tables at compile-time.

  > #### Warning {: .warning}
  >
  > When you call a function from inside a `@moduledoc` tag, it is evaluated
  > at *compile-time*. `Inspecto` _should_ filter out problems and avoid raising
  > errors, but if it generates a problem for any reason, be aware that you may
  > need to remove any calls to its functions from your `@moduledoc` tags.
  """

  alias Inspecto.Schema

  require EEx

  @local_path Application.app_dir(:inspecto, ["priv/resources"])

  @doc """
  Summarizes the given Ecto schema modules using the format provided.

  It is necessary to supply a list of modules.

  ## Options

  - `:format` controls the format of the output. Supported values: `:html`, `:raw` (default).
  - `:h` controls the heading level used for each schema (`3` corresponds to an `h3` tag).
    This is only relevant when `:format` is set to `:html`. Default: `2`

  The `:raw` format returns information as a list of `Inspecto.Schema` structs.

  The `:html` format returns information as an HTML table. This is suitable for
  use inside a `@moduledoc` attribute.

  Other formats may be supported in the future (e.g. Mermaid JS, but it's not yet
  compatible with how documentation generation strips out newlines).

  ## Examples

      iex> MyApp.Schemas |> Inspecto.modules() |> Inspecto.summarize(format: :raw)
      [
        %Inspecto.Schema{
          fields: [
            %Inspecto.Schema.Field{default: nil, name: :id, type: :binary_id},
            %Inspecto.Schema.Field{default: nil, name: :meta, type: :map},
            %Inspecto.Schema.Field{default: 30, name: :net, type: :integer},
            # ...
          ],
          module:MyApp.Schemas.SomeSchema,
          primary_key: [:id],
          source: "some_table"
        }
      ],
      #  ...
  """
  @spec summarize(modules :: [module()], opts :: Keyword.t()) :: String.t() | [Schema.t()]
  def summarize(modules, opts \\ []) when is_list(modules) do
    format = Keyword.get(opts, :format, :raw)
    heading_level = Keyword.get(opts, :h, 2)

    modules
    |> Enum.reduce([], fn m, acc ->
      case Schema.inspect(m) do
        {:ok, schema} -> [schema | acc]
        {:invalid_module, _} -> acc
      end
    end)
    |> Enum.reverse()
    |> apply_format(format, heading_level)
  end

  defp apply_format(schemas, :raw, _), do: schemas

  defp apply_format(schemas, :html, heading_level), do: table_wrapper(schemas, heading_level)

  EEx.function_from_file(
    :defp,
    :table_wrapper,
    "#{@local_path}/table_wrapper.eex",
    [:schemas, :heading_level]
  )

  EEx.function_from_file(:defp, :table, "#{@local_path}/table.eex", [:schema, :heading_level])

  defp stringify(module), do: String.trim_leading("#{module}", "Elixir.")

  @doc """
  This is a convenience function which retrieves a list of modules in the given
  "namespace". This is a useful way of gathering up modules that define Ecto
  schemas.

  ## Examples

      iex> Inspecto.modules(MyApp)
      [MyApp.Foo, MyApp.Bar, ...]
  """
  def modules(namespace) when is_atom(namespace) do
    :code.all_available()
    |> Enum.filter(fn {name, _file, _loaded} ->
      String.starts_with?(to_string(name), to_string(namespace))
    end)
    |> Enum.map(fn {name, _file, _loaded} ->
      name |> List.to_atom()
    end)
  end
end
