# Inspecto

  `Inspecto` is a utility for inspecting Ecto schemas to view the field names,
  data types, and default values.

  Note that Ecto schema modules do not contain full information about your database schemas: they only contain enough information to act as a viable intermediary for the Elixir layer.  You cannot, for example, know character length limits or input constraints by merely inspecting Ecto schemas.  Although Ecto _migrations_ contain a lot more of this information, they too aren't great for the purpose because migrations are additive with changes spread out over time, and importantly, there's not requirement that a database be defined via migrations.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `inspecto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:inspecto, "~> 0.1.0"}
  ]
end
```

## Usage

The envisioned usage of this packge is to call it from within one of your application's `@moduledoc` tags.  

## Image Attribution

Inspect by Musaplated from [NounProject.com](https://thenounproject.com/icon/inspect-147710/)
