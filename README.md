# Demo Elixir Ash Backpex

Demonstration of:

- [Elixir](https://?) programming language
- [Ash](https://hexdocs.pm/ash/) resource domain modeler
- [Backpex](https://hexdocs.pm/ash/) administration dashboard
- [AshBackpex](https://hexdocs.pm/ash_backpex/) Ash Backpex adapter


## How to run this

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
- Visit [`localhost:4000`](http://localhost:4000) from your browser.


## How to build this project from scratch

The rest of this page is a tutorial that teaches how to build this project from scratch.

For the tutorial, we use the fake app name "MyApp".

For the tutorial, we use the fake domain name "MyApp.MyDomain".

In this repo, the real app name is "MyApp".


## Install dependencies

Install Erlang, Elixir, and Postgres; use any way you like.

<details>
  <summary>Install via mise</summary>

Use:

```sh
mise use erlang@latest
mise use elixir@latest
mise use postgres@latest
```

Start Postgres and connect to it:

```sh
"$(mise where postgres)/bin/pg_ctl" -D "$(mise where postgres)/data" -l "$(mise where postgres)/log" start
"$(mise where postgres)/bin/psql" postgres postgres
```

</details>


## Install Phoenix and Igniter

Install Phoenix web framework and Igniter code generation framework:

```sh
mix archive.install hex phx_new
mix archive.install hex igniter_new
```


## Create a new application

Create a new Elixir Ash Phoenix Postgres application:

  ```sh
mix igniter.new my_app --with phx.new --install ash,ash_phoenix,ash_postgres,ash_backpex,backpex
cd my_app
mix ash.setup
```

<details>
  <summary>Output</summary>

```stdout
Compiling 15 files (.ex)
Generated demo_elixir_ash_backpex app
Getting extensions in current project...
Running setup for AshPostgres.DataLayer...
The database for MyApp.Repo has already been created

19:13:04.871 [info] == Running 20250915181105 MyApp.Repo.Migrations.InitializeExtensions1.up/0 forward

19:13:04.872 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_or(left BOOLEAN, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE)\nAS $$ SELECT COALESCE(NULLIF($1, FALSE), $2) $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

19:13:04.873 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_or(left ANYCOMPATIBLE, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE)\nAS $$ SELECT COALESCE($1, $2) $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

19:13:04.873 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_and(left BOOLEAN, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE) AS $$\n  SELECT CASE\n    WHEN $1 IS TRUE THEN $2\n    ELSE $1\n  END $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

19:13:04.873 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_and(left ANYCOMPATIBLE, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE) AS $$\n  SELECT CASE\n    WHEN $1 IS NOT NULL THEN $2\n    ELSE $1\n  END $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

19:13:04.873 [info] execute "CREATE OR REPLACE FUNCTION ash_trim_whitespace(arr text[])\nRETURNS text[] AS $$\nDECLARE\n    start_index INT = 1;\n    end_index INT = array_length(arr, 1);\nBEGIN\n    WHILE start_index <= end_index AND arr[start_index] = '' LOOP\n        start_index := start_index + 1;\n    END LOOP;\n\n    WHILE end_index >= start_index AND arr[end_index] = '' LOOP\n        end_index := end_index - 1;\n    END LOOP;\n\n    IF start_index > end_index THEN\n        RETURN ARRAY[]::text[];\n    ELSE\n        RETURN arr[start_index : end_index];\n    END IF;\nEND; $$\nLANGUAGE plpgsql\nSET search_path = ''\nIMMUTABLE;\n"

19:13:04.877 [info] execute "CREATE OR REPLACE FUNCTION ash_raise_error(json_data jsonb)\nRETURNS BOOLEAN AS $$\nBEGIN\n    -- Raise an error with the provided JSON data.\n    -- The JSON object is converted to text for inclusion in the error message.\n    RAISE EXCEPTION 'ash_error: %', json_data::text;\n    RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql\nSTABLE\nSET search_path = '';\n"

19:13:04.878 [info] execute "CREATE OR REPLACE FUNCTION ash_raise_error(json_data jsonb, type_signal ANYCOMPATIBLE)\nRETURNS ANYCOMPATIBLE AS $$\nBEGIN\n    -- Raise an error with the provided JSON data.\n    -- The JSON object is converted to text for inclusion in the error message.\n    RAISE EXCEPTION 'ash_error: %', json_data::text;\n    RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql\nSTABLE\nSET search_path = '';\n"

19:13:04.878 [info] execute "CREATE OR REPLACE FUNCTION uuid_generate_v7()\nRETURNS UUID\nAS $$\nDECLARE\n  timestamp    TIMESTAMPTZ;\n  microseconds INT;\nBEGIN\n  timestamp    = clock_timestamp();\n  microseconds = (cast(extract(microseconds FROM timestamp)::INT - (floor(extract(milliseconds FROM timestamp))::INT * 1000) AS DOUBLE PRECISION) * 4.096)::INT;\n\n  RETURN encode(\n    set_byte(\n      set_byte(\n        overlay(uuid_send(gen_random_uuid()) placing substring(int8send(floor(extract(epoch FROM timestamp) * 1000)::BIGINT) FROM 3) FROM 1 FOR 6\n      ),\n      6, (b'0111' || (microseconds >> 8)::bit(4))::bit(8)::int\n    ),\n    7, microseconds::bit(8)::int\n  ),\n  'hex')::UUID;\nEND\n$$\nLANGUAGE PLPGSQL\nSET search_path = ''\nVOLATILE;\n"

19:13:04.878 [info] execute "CREATE OR REPLACE FUNCTION timestamp_from_uuid_v7(_uuid uuid)\nRETURNS TIMESTAMP WITHOUT TIME ZONE\nAS $$\n  SELECT to_timestamp(('x0000' || substr(_uuid::TEXT, 1, 8) || substr(_uuid::TEXT, 10, 4))::BIT(64)::BIGINT::NUMERIC / 1000);\n$$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE PARALLEL SAFE STRICT;\n"

19:13:04.879 [info] == Migrated 20250915181105 in 0.0s
```

</details>


## config.exs

Backpex changes file [`config.exs`](config.exs):

```elixir
config :backpex, :pubsub_server, MyApp.PubSub
```


## app.js

Backpex changes file [`assets/js/app.js`](assets/js/app.js):

```js
import { Hooks as BackpexHooks } from 'backpex';

const Hooks = [] // your application hooks (optional)

const liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {...Hooks, ...BackpexHooks }
})
```


## app.css

Backpex changes file [`assets/css/app.css`](assets/css/app.css):

```css
@source "../../deps/backpex/**/*.*ex";
@source "../../deps/backpex/assets/js/**/*.*js";
```

## router.ex

Backpex changes file [`lib/my_app_web/router.ex`](lib/my_app_web/router.ex):

```elixir
import Backpex.Router
…
scope "/", MyAppWeb do
  pipe_through :browser
  backpex_routes()
end
```


## Create Backpex app formatter

Create app formatter file [`lib/my_app/.formatter.exs`](lib/my_app/.formatter.exs):

```elixir
[
  import_deps: [:backpex]
]
```

## Create templates layout

To get started quickly, use the simple layout below and the predefined layout name `admin`:

```sh
mkdir -p lib/my_app_web/templates/layout/
```

Create file [`lib/my_app_web/templates/layout/admin.html.heex`](lib/my_app_web/templates/layout/admin.html.heex):

```heex
<Backpex.HTML.Layout.app_shell fluid={@fluid?}>
  <:topbar>
    <Backpex.HTML.Layout.topbar_branding />

    <Backpex.HTML.Layout.topbar_dropdown class="mr-2 md:mr-0">
      <:label>
        <div class="btn btn-square btn-ghost">
          <Backpex.HTML.CoreComponents.icon name="hero-user" class="size-6" />
        </div>
      </:label>
      <li>
        <.link href="/" class="text-error flex justify-between hover:bg-base-200">
          <p>Logout</p>
          <Backpex.HTML.CoreComponents.icon name="hero-arrow-right-on-rectangle" class="size-5" />
        </.link>
      </li>
    </Backpex.HTML.Layout.topbar_dropdown>
  </:topbar>
  <:sidebar>
    <!-- Sidebar Content -->
  </:sidebar>
  <Backpex.HTML.Layout.flash_messages flash={@flash} />
  {render_slot(@inner_block)}
</Backpex.HTML.Layout.app_shell>
```

## Adjust components layouts

To get started quickly, edit file [`lib/my_app_web/components/layouts.ex`](lib/my_app_web/components/layouts.ex).

Find existing line:

```elixir
attr :flash, :map, required: true, doc: "the map of flash messages"
```

Append more declarative assigns:

```elixir
attr :fluid?, :boolean, default: true, doc: "if the content uses full width"
attr :current_url, :string, required: true, doc: "the current url"
```

Find end of module.

Insert a bodyless function to handle the Backpex layout:

```elixir
def admin(assigns)
```

## Create a resource

Create a resource of any kind, such as an item, with our preferred options:

```sh
mix ash.gen.resource MyApp.MyDomain.Item \
--extend postgres \
--uuid-primary-key id \
--default-actions create,read,update,destroy \
--attribute name:string:public \
--attribute note:string:public
```

<details>
  <summary>Explanation</summary>

- `--uuid-primary-key` - Add a UUIDv4 primary key with the given name. If you prefer, you can add a UUIDv7 primary key via `--uuid-v7-primary-key`.

  - Examples: `--uuid-primary-key id` or `--uuid-v7-primary-key id`

- `--timestamps` - Add timestamps as attributes `inserted_at` and `updated_at`.

- `--default-actions` - A comma-separated list of default action types to add. The create and update actions accept the public attributes being added.

  - Example: `--default-actions create,read,update,destroy`.

- `--extend` - A comma-separated list of modules or builtins with which to extend the resource.

  - Example: `--extend postgres,graphql,Some.Extension`

</details>

<details>
  <summary>Output</summary>

Update: [`lib/my_app/my_domain.ex`](lib/my_app/my_domain.ex)

```stdout
   ...|
4 4   |
5 5   |  resources do
  6 + |    resource MyApp.MyDomain.Item
6 7   |  end
7 8   |end
   ...|
```

Create file [`lib/my_app/my_domain/item.ex`](lib/my_app/my_domain/item.ex):

```elixir
defmodule MyApp.MyDomain.Item do
  use Ash.Resource, otp_app: :my_app, domain: MyApp.MyDomain, data_layer: AshPostgres.DataLayer

  postgres do
    table "items"
    repo MyApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name, :note], update: [:name, :note]]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
    end

    attribute :note, :string do
      public? true
    end
  end
end
```

</details>


## Migrate

Generate the migration:

```sh
mix ash.codegen create_items
```

<details>
  <summary>Output</summary>

```stdout
Compiling 17 files (.ex)
Generated my_app app
Getting extensions in current project...
Running codegen for AshPostgres.DataLayer...
* creating priv/repo/migrations/20251025032759_create_items.exs
* creating priv/resource_snapshots/repo/items/20251025032759.json
```

</details>

Run the migration:

```sh
mix ash.migrate
```

<details>
  <summary>Output</summary>

```stdout
Getting extensions in current project...
Running migration for AshPostgres.DataLayer...

04:28:41.556 [info] == Running 20251025032759 MyApp.Repo.Migrations.CreateItems.up/0 forward

04:28:41.557 [info] create table items

04:28:41.560 [info] == Migrated 20251025032759 in 0.0s
```

</details>

## Create web directory

Create a web directory such as:

```sh
mkdir -p lib/my_app_web/backpex
```


## Create Backpex adapter

Create file [`lib/my_app_web/item_live.ex`](lib/my_app_web/item_live.ex):

```elixir
defmodule MyAppWeb.ItemLive do
  use AshBackpex.LiveResource

  backpex do
    resource MyApp.MyDomain.Item
    layout &MyAppWeb.Layouts.admin/1

    fields do
      field :name
      field :note
    end
  end
end
```


## Router with Backpex

Edit file [`lib/my_app_web/router.ex`](lib/my_app_web/router.ex) to add live_session live_resources:

```elixir
scope "/", MyAppWeb do
  pipe_through :browser
  backpex_routes()
  get "/", PageController, :home

  live_session :default, on_mount: Backpex.InitAssigns do
    live_resources "/items", ItemLive
  end
end
```

## Fix current_user

This demo deliberately doesn't do authentication, so we must fix the current_user variable.

Create [`lib/my_app_web/init_assigns.ex`](lib/my_app_web/init_assigns.ex):

```elixir
defmodule MyAppWeb.InitAssigns do
  @moduledoc """
  Custom Ash Backpex LiveViews on_mount hook that initializes assigns.
  This sets the assigns.current_user suitable for demo authorization.
  """

  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    # For now, we'll set current_user to nil to bypass authorization
    # TODO: Replace this with actual authentication logic
    # For example, if you're using a session-based auth:
    # current_user = get_user_from_session(session)

    socket =
      socket
      |> assign(:current_user, nil)

    {:cont, socket}
  end
end
```

Edit [`lib/my_app_web/router.ex`](lib/my_app_web/router.ex) to add `MyAppWeb.InitAssigns`:

```elixir
live_session :default, on_mount: [MyAppWeb.InitAssigns, Backpex.InitAssigns] do
  live_resources "/items", ItemLive
end
```

## Create item

Run:

```sh
iex -S mix
```

Create an item:

```elixir
MyApp.MyDomain.Item |> Ash.Changeset.for_create(:create, %{name: "Alfa", note: "Bravo"}) |> Ash.create!()
```

<details>
  <summary>Output</summary>

```elixir
%MyApp.MyDomain.Item{
  id: "fc13f60c-0cfd-4e5e-b48c-d058ce758e19",
  name: "Alfa",
  note: "Bravo",
  __meta__: #Ecto.Schema.Metadata<:loaded, "items">
}
```

</details>

Verify the item:

```elixir
MyApp.MyDomain.Item |> Ash.read!()
```

<details>
  <summary>Output</summary>

```elixir
[
  %MyApp.MyDomain.Item{
    id: "11e937e5-53d1-4710-92bd-1197f2f7eb11",
    name: "alfa",
    note: "bravo",
    __meta__: #Ecto.Schema.Metadata<:loaded, "items">
  }
]
```

</details>


## Success

Run:

```sh
mix phx.server
```

Browse <http://localhost:4000/items>

You should see the Backpex logo page and the item.
