# Inspecto

[![Module Version](https://img.shields.io/hexpm/v/inspecto.svg)](https://hex.pm/packages/inspecto)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/inspecto/)
[![Total Download](https://img.shields.io/hexpm/dt/inspecto.svg)](https://hex.pm/packages/inspecto)
[![License](https://img.shields.io/hexpm/l/inspecto.svg)](https://hex.pm/packages/inspecto)
[![Last Updated](https://img.shields.io/github/last-commit/fireproofsocks/inspecto.svg)](https://github.com/fireproofsocks/inspecto/commits/master)

`Inspecto` is a utility for inspecting Ecto schemas to view the field names,
  data types, and default values.

Note that Ecto schema modules do not contain full information about your database schemas: they only contain enough information to act as a viable intermediary for the Elixir layer.  You cannot, for example, know character length limits or input constraints by merely inspecting Ecto schemas.  Although Ecto _migrations_ contain a lot more of this information, they too aren't great for the purpose because (by design) migrations are additive with changes spread out over time, and importantly, ther is no requirement that a database be defined via migrations! So `Inspecto` attempts to provide insight into what it can.

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

The envisioned usage of this packge is to call it from within one of your application's `@moduledoc` tags, e.g.

```elixir
defmodule MyApp.MyModel do
  @moduledoc \"\"\"
  Here is a summary of my Ecto schemas:

  \#\{ MyApp.MyModel |> Inspecto.modules() |> Inspecto.summarize(format: :html)\}
  \"\"\"
end
```

## Image Attribution

Inspect by Musaplated from [NounProject.com](https://thenounproject.com/icon/inspect-147710/)
