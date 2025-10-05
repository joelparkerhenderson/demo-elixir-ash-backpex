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

In this repo, the real app name is "DemoElixirAshBackpex".


## Install dependencies

Install Erlang, Elixir, and Postgres; use any way you like, such as via mise:

```sh
mise use erlang@latest 
mise use elixir@latest 
mise use postgres@latest
```

Start Postgres and connect to it; use any way you like, such as via mise:

```sh
"$(mise where postgres)/bin/pg_ctl" -D "$(mise where postgres)/data" -l "$(mise where postgres)/log" start
"$(mise where postgres)/bin/psql" postgres postgres
```

Install Phoenix web framework and Igniter code generation framework:

```sh
mix archive.install hex phx_new
mix archive.install hex igniter_new
```


## Create a new application

Create a new Elixir Ash Phoenix Postgres application:

  ```sh
mix igniter.new my_app --with phx.new --install ash,ash_authentication,ash_authentication_phoenix,ash_phoenix,ash_postgres,ash_backpex,backpex
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
The database for DemoElixirAshBackpex.Repo has already been created

19:13:04.871 [info] == Running 20250915181105 DemoElixirAshBackpex.Repo.Migrations.InitializeExtensions1.up/0 forward

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


## Fix Backpex admin router

Backpex changes file [`lib/my_app_web/router.ex`](lib/my_app_web/router.ex) and it needs a fix up:

```elixir
import Backpex.Router

scope "/admin", MyAppWeb do
  pipe_through :browser

  backpex_routes()
end
```

## Create Backpex app formatter

Create app formatter file [`lib/my_app/.formatter.exs`](lib/my_app/.formatter.exs)>:

```elixir
[
  import_deps: [:backpex]
]
```

## Create templates layout

To get started quickly:

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
        <label tabindex="0" class="btn btn-square btn-ghost">
          <Backpex.HTML.CoreComponents.icon name="hero-user" class="size-6" />
        </label>
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
  {render_slot(@inner_content)}
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

Insert a bodyless function:

```elixir
def admin(assigns)
```

## Create web admin

Create a web live admin directory such as:

```sh
mkdir -p lib/my_app_web/live/admin/
```

## Create a domain

```sh
mix ash.gen.domain MyApp.MyDomain
```

## Create a resource

Create a resource of any kind, such as an item, with our preferred options:

```sh
mix ash.gen.resource MyApp.MyDomain.Item \
--extend postgres \
--uuid-primary-key id \
--default-actions create,read,update,destroy \
--attribute name:string:required:public \
--attribute note:string:public
```

<details>
  <summary>Explanation</summary>

- `--uuid-primary-key` - Add a UUIDv4 primary key with the given name. If you prefer, you can add a UUIDv7 primary key via `--uuid-v7-primary-key`.

  - Examples: `--uuid-primary-key id` or `--uuid-v7-primary-key id`

- `--timestamps` - Add timestamps as attributes `inserted_at` and `updated_at`.

- `--default-actions` - A comma-separated list of default action types to add. The create and update actions accept the public attributes being added.
  
  - Example: `--default-actions create,read,update,destroy`. 

- `--extend` - A comma -eparated list of modules or builtins with which to extend the resource. 

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
defmodule DemoElixirAshBackpex.MyDomain.Item do
  use Ash.Resource,
    otp_app: :demo_elixir_ash,
    domain: DemoElixirAshBackpex.MyDomain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "items"
    repo DemoElixirAsh.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name, :note], update: [:name, :note]]
  end

  attributes do
    uuid_primary_key :id
    
    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :note, :string do
      public? true
    end

  end
end
```

</details>

Edit file [`lib/my_app/my_domain/item.ex`](lib/my_app/my_domain/item.ex).

After the primary key, append these timestamp attributes:

```elixir
create_timestamp :created_at
update_timestamp :updated_at
```

## Migrate

Generate the migration:

```sh
mix ash.codegen create_items
```

<details>
  <summary>Output</summary>

```stdout
Compiling 17 files (.ex)
Generated demo_elixir_ash app
Getting extensions in current project...
Running codegen for AshPostgres.DataLayer...
- creating priv/repo/migrations/20250907164015_create_items.exs
- creating priv/resource_snapshots/repo/items/20250907164015.json
```

</details>

Run the migration:

```sh
mix ash.migrate
```

<details>
  <summary>Output</summary>

```stdout
17:43:40.904 [info] == Running 20250907164015 DemoElixirAsh.Repo.Migrations.CreateItems.up/0 forward

17:43:40.904 [info] create table items

17:43:40.916 [info] == Migrated 20250907164015 in 0.0s
```

</details>

## Create Backpex adapter

Create file [`lib/my_app_web/live/admin/item_live.ex`](lib/my_app_web/live/admin/item_live.ex):

```elixir
defmodule MyAppWeb.Admin.ItemLive do
    use AshBackpex.LiveResource

    backpex do
      resource(MyApp.MyDomain.Item)
      layout({MyAppWeb.Layouts, :admin})

      fields do
        field :name
        field :note
      end
    end
end
```


## Router with Backpex

Edit file [`lib/my_app_web/router.ex`](lib/my_app_web/router.ex) to add these admin live_session live_resources:

```elixir
scope "/admin", MyAppWeb do
  pipe_through :browser

  backpex_routes()

  ash_authentication_live_session :admin_routes, on_mount: Backpex.InitAssigns do
    live_resources "/items", Admin.ItemLive
  end
end
```


## Router with Ash

Edit file [`lib/my_app_web/router.ex`](lib/my_app_web/router.ex) to add these live routes:

```elixir
scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/items", Items.IndexLive
    live "/items/new", Items.FormLive, :new
    live "/items/:id", Items.ShowLive
    live "/items/:id/edit", Items.FormLive, :edit
end
```


## LiveView

Run:

```sh
mkdir -p lib/my_app_web/live/items
```

## index

Create file [`lib/my_app_web/live/items/index_live.ex`](lib/my_app_web/live/items/index_live.ex)

<details>
    <summary>heex</summary>

```heex
defmodule DemoElixirAshBackpexWeb.Items.IndexLive do
  use DemoElixirAshBackpexWeb, :live_view
  alias DemoElixirAshBackpex.MyDomain.Item, as: X

  require Logger

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Items")

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    # items = DemoElixirAshBackpex.MyDomain.items_read!()
    items = X
    |> Ash.Query.for_read(:read)
    |> Ash.read!()

    {:noreply,
      socket
      |> assign(:page_title, "Items")
      |> assign(:items, items)
    }
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@page_title}
        <:actions>
          <.button
            navigate={~p"/items/new"}
          >
            New
          </.button>
        </:actions>
      </.header>

      <%= if @items == [] do %>
        <div>
          None.
        </div>
      <% else %>
        <ul>
          <li :for={item <- @items}>
            <.render_item item={item} />
          </li>
        </ul>
      <% end %>
    </Layouts.app>
    """
  end

  def render_item(assigns) do
    ~H"""
    <.link
      navigate={~p"/items/#{@item.id}"}
      data-role="item-name"
    >
      {@item.name}
    </.link>
    """
  end

end
```

</details>

## show

Create file [`lib/my_app_web/live/items/show_live.ex`](lib/my_app_web/live/items/show_live.ex)

<details>
    <summary>heex</summary>

```heex
defmodule DemoElixirAshBackpexWeb.Items.ShowLive do
  use DemoElixirAshBackpexWeb, :live_view
  alias DemoElixirAshBackpex.MyDomain.Item, as: X

  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    item = Ash.get!(X, id)

    {:noreply,
      socket
      |> assign(:page_title, item.name)
      |> assign(:item, item)
    }
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@page_title}
        <:actions>
          <.button
            data-confirm={"Are you sure you want to delete #{@item.name}?"}
            phx-click={"delete-#{@item.id}"}
          >
            Delete
          </.button>
          <.button
            navigate={~p"/items/#{@item.id}/edit"}
          >
            Edit
          </.button>
        </:actions>
      </.header>
      <main>
        {@item.note}
      </main>
    </Layouts.app>
    """
  end

  def handle_event("delete-" <> id, _params, socket) do
    case Ash.get!(X, id) |> Ash.destroy() do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "Deleted.")
         |> push_navigate(to: ~p"/items")
        }
      {:error, error} ->
          Logger.warning("Delete failed for item '#{id}':
          #{inspect(error)}")
          {:noreply,
            socket
            |> put_flash(:error, "Delete failed.")
          }
    end
  end

end
```

</details>

## form

Create file [`lib/my_app_web/live/items/form_live.ex`](lib/my_app_web/live/items/form_live.ex)

<details>
    <summary>heex</summary>

```heex
defmodule DemoElixirAshBackpexWeb.Items.FormLive do
  use DemoElixirAshBackpexWeb, :live_view
  alias DemoElixirAshBackpex.MyDomain.Item, as: X

  require Logger

  # Update
  def mount(%{"id" => id}, _session, socket) do
      form = AshPhoenix.Form.for_create(DemoElixirAshBackpex.MyDomain.Item, :create)
      item = Ash.get!(X, id)

      socket =
      socket
      |> assign(:page_title, "Update Item")
      |> assign(:form, to_form(form))
      |> assign(:item, item)

      {:ok, socket}
  end

  # Create
  def mount(_params, _session, socket) do
      form = AshPhoenix.Form.for_create(X, :create)

      socket =
        socket
        |> assign(:page_title, "Create Item")
        |> assign(:form, to_form(form))

      {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@page_title}
      </.header>

      <.form
        :let={form}
        id="item_form"
        for={@form}
        as={:form}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={form[:name]} label="Name" />
        <.input field={form[:note]} type="textarea" label="Note" />
        <.button type="primary">Save</.button>
      </.form>
    </Layouts.app>
    """
  end

# Validate
def handle_event("validate", %{"form" => form_data}, socket) do
    socket =
        update(socket, :form, fn form ->
            AshPhoenix.Form.validate(form, form_data)
        end)

    {:noreply, socket}
end

# Save
def handle_event("save", %{"form" => form_data}, socket) do
  case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
    {:ok, item} ->
      {:noreply,
        socket
        |> put_flash(:info, "Saved.")
        |> push_navigate(to: ~p"/items/#{item}")
      }

    {:error, form} ->
      {:noreply,
        socket
        |> put_flash(:error, "Save failed.")
        |> assign(:form, form)
    }

  end
end

end
```

</details>

## Use Ash macros

Edit `lib/my_app/my_domain.ex`.

Add code:

```elixir
defmodule MyApp.MyDomain do

    # Use Ash extensions for Phoenix so we can use syntax sugar.
    #
    # Example query with sugar:
    #
    #     items = MyApp.MyDomain.items_read!()
    #
    # Example query without sugar:
    #
    #     items = DemoElixirAshBackpex.MyDomain.Item
    #     |> Ash.Query.for_read(:read)
    #     |> Ash.read!()
    #
    # Example form with sugar:
    #
    #     MyApp.MyDomain.form_to_item_create
    #
    # Example form without sugar:
    #
    #     AshPhoenix.Form.for_create(MyApp.MyDomain.Item, :create)
    #
    use Ash.Domain, otp_app: :my_app, extensions: [AshPhoenix]
    resources do
        resource MyApp.MyDomain.item do
            define :item_create, action: :create
            define :item_read, action: :read
            define :item_read_id, action: :read, get_by: :id
            define :item_update, action: :update
            define :item_destroy, action: :destroy
        end
    end
end
```

## Success

Run:

```sh
mix phx.server
```

Browse <http://localhost:4000>

## Ash Authentication

We prefer to create authentication via magic link, not password.

Run:

```sh
mix igniter.install ash_authentication_phoenix --auth-strategy magic_link
```

<details>
  <summary>Output</summary>

```stdout
Update: mix.exs

       ...|
 42  42   |  defp deps do
 43  43   |    [
     44 + |      {:ash_authentication_phoenix, "~> 2.0"},
 44  45   |      {:absinthe_phoenix, "~> 2.0"},
 45  46   |      {:usage_rules, "~> 0.1"},
       ...|


Modify mix.exs and install? [Y/n] 
compiling ash_authentication_phoenix ✔
Could not find accounts module. Please set the equivalent CLI flag.

There are two likely causes:

1. You have an existing accounts module that does not have the default name.
    If this is the case, quit this command and use the
    --accounts flag to specify the correct module.
2. You have not yet run the `ash_authentication` installer.
    To run this, answer Y to this prompt.

Run the installer now?
 [Yn] 

Compiling 18 files (.ex)
Generated navatrack app
installing new dependencies ✔
`ash_authentication_phoenix.install` ✔

The following installer was found and executed: `ash_authentication_phoenix.install`:

Update: .formatter.exs

 1  1   |[
 2  2   |  import_deps: [
    3 + |    :ash_authentication,
    4 + |    :ash_authentication_phoenix,
 3  5   |    :backpex,
 4  6   |    :ash_state_machine,
     ...|


Create: .igniter.exs

1  |# This is a configuration file for igniter.
2  |# For option documentation, see https://hexdocs.pm/igniter/Igniter.Project.IgniterConfig.html
3  |# To keep it up to date, use `mix igniter.setup`
4  |[
5  |  module_location: :outside_matching_folder,
6  |  extensions: [{Igniter.Extensions.Phoenix, []}],
7  |  deps_location: :last_list_literal,
8  |  source_folders: ["lib", "test/support"],
9  |  dont_move_files: [~r"lib/mix"]
10 |]
11 |


Update: assets/css/app.css

       ...|
  3   3   |
  4   4   |@import "tailwindcss" source(none);
      5 + |@source "../../deps/ash_authentication_phoenix";
  5   6   |@source "../css";
  6   7   |@source "../js";
       ...|


Update: config/config.exs

       ...|
 44  44   |    "Ash.Resource": [
 45  45   |      section_order: [
     46 + |        :authentication,
     47 + |        :tokens,
 46  48   |        :postgres,
 47  49   |        :json_api,
       ...|
 81  83   |  ecto_repos: [Navatrack.Repo],
 82  84   |  generators: [timestamp_type: :utc_datetime],
 83     - |  ash_domains: []
     85 + |  ash_domains: [Navatrack.Accounts]
 84  86   |
 85  87   |# Configures the endpoint
       ...|


Update: config/dev.exs

     ...|
66 66   |
67 67   |# Enable dev routes for dashboard and mailbox
68    - |config :navatrack, dev_routes: true
   68 + |config :navatrack, dev_routes: true, token_signing_secret: "c1s+dj5IQ+HJJVXqbp38aIO5Msg4DF1T"
69 69   |
70 70   |# Do not include metadata nor timestamps in development logs
     ...|


Update: config/runtime.exs

       ...|
 68  68   |    secret_key_base: secret_key_base
 69  69   |
     70 + |  config :navatrack,
     71 + |    token_signing_secret:
     72 + |      System.get_env("TOKEN_SIGNING_SECRET") ||
     73 + |        raise("Missing environment variable `TOKEN_SIGNING_SECRET`!")
     74 + |
 70  75   |  # ## SSL Support
 71  76   |  #
       ...|


Update: config/test.exs

 1  1   |import Config
    2 + |config :navatrack, token_signing_secret: "gYndTlBy8FSka0T0jx+Bu88K2L2UKwaT"
    3 + |config :bcrypt_elixir, log_rounds: 1
 2  4   |config :navatrack, Oban, testing: :manual
 3  5   |config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true
     ...|


Create: lib/navatrack/accounts.ex

1  |defmodule Navatrack.Accounts do
2  |  use Ash.Domain,
3  |    otp_app: :navatrack
4  |
5  |  resources do
6  |    resource Navatrack.Accounts.Token
7  |    resource Navatrack.Accounts.User
8  |  end
9  |end
10 |


Create: lib/navatrack/accounts/token.ex

1   |defmodule Navatrack.Accounts.Token do
2   |  use Ash.Resource,
3   |    otp_app: :navatrack,
4   |    domain: Navatrack.Accounts,
5   |    data_layer: AshPostgres.DataLayer,
6   |    authorizers: [Ash.Policy.Authorizer],
7   |    extensions: [AshAuthentication.TokenResource]
8   |
9   |  postgres do
10  |    table "tokens"
11  |    repo Navatrack.Repo
12  |  end
13  |
14  |  actions do
15  |    defaults [:read]
16  |
17  |    read :expired do
18  |      description "Look up all expired tokens."
19  |      filter expr(expires_at < now())
20  |    end
21  |
22  |    read :get_token do
23  |      description "Look up a token by JTI or token, and an optional purpose."
24  |      get? true
25  |      argument :token, :string, sensitive?: true
26  |      argument :jti, :string, sensitive?: true
27  |      argument :purpose, :string, sensitive?: false
28  |
29  |      prepare AshAuthentication.TokenResource.GetTokenPreparation
30  |    end
31  |
32  |    action :revoked?, :boolean do
33  |      description "Returns true if a revocation token is found for the provided token"
34  |      argument :token, :string, sensitive?: true
35  |      argument :jti, :string, sensitive?: true
36  |
37  |      run AshAuthentication.TokenResource.IsRevoked
38  |    end
39  |
40  |    create :revoke_token do
41  |      description "Revoke a token. Creates a revocation token corresponding to the provided token."
42  |      accept [:extra_data]
43  |      argument :token, :string, allow_nil?: false, sensitive?: true
44  |
45  |      change AshAuthentication.TokenResource.RevokeTokenChange
46  |    end
47  |
48  |    create :revoke_jti do
49  |      description "Revoke a token by JTI. Creates a revocation token corresponding to the provided jti."
50  |      accept [:extra_data]
51  |      argument :subject, :string, allow_nil?: false, sensitive?: true
52  |      argument :jti, :string, allow_nil?: false, sensitive?: true
53  |
54  |      change AshAuthentication.TokenResource.RevokeJtiChange
55  |    end
56  |
57  |    create :store_token do
58  |      description "Stores a token used for the provided purpose."
59  |      accept [:extra_data, :purpose]
60  |      argument :token, :string, allow_nil?: false, sensitive?: true
61  |      change AshAuthentication.TokenResource.StoreTokenChange
62  |    end
63  |
64  |    destroy :expunge_expired do
65  |      description "Deletes expired tokens."
66  |      change filter expr(expires_at < now())
67  |    end
68  |
69  |    update :revoke_all_stored_for_subject do
70  |      description "Revokes all stored tokens for a specific subject."
71  |      accept [:extra_data]
72  |      argument :subject, :string, allow_nil?: false, sensitive?: true
73  |      change AshAuthentication.TokenResource.RevokeAllStoredForSubjectChange
74  |    end
75  |  end
76  |
77  |  policies do
78  |    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
79  |      description "AshAuthentication can interact with the token resource"
80  |      authorize_if always()
81  |    end
82  |  end
83  |
84  |  attributes do
85  |    attribute :jti, :string do
86  |      primary_key? true
87  |      public? true
88  |      allow_nil? false
89  |      sensitive? true
90  |    end
91  |
92  |    attribute :subject, :string do
93  |      allow_nil? false
94  |      public? true
95  |    end
96  |
97  |    attribute :expires_at, :utc_datetime do
98  |      allow_nil? false
99  |      public? true
100 |    end
101 |
102 |    attribute :purpose, :string do
103 |      allow_nil? false
104 |      public? true
105 |    end
106 |
107 |    attribute :extra_data, :map do
108 |      public? true
109 |    end
110 |
111 |    create_timestamp :created_at
112 |    update_timestamp :updated_at
113 |  end
114 |end
115 |


Create: lib/navatrack/accounts/user.ex

1   |defmodule Navatrack.Accounts.User do
2   |  use Ash.Resource,
3   |    otp_app: :navatrack,
4   |    domain: Navatrack.Accounts,
5   |    data_layer: AshPostgres.DataLayer,
6   |    authorizers: [Ash.Policy.Authorizer],
7   |    extensions: [AshAuthentication]
8   |
9   |  authentication do
10  |    add_ons do
11  |      log_out_everywhere do
12  |        apply_on_password_change? true
13  |      end
14  |    end
15  |
16  |    tokens do
17  |      enabled? true
18  |      token_resource Navatrack.Accounts.Token
19  |      signing_secret Navatrack.Secrets
20  |      store_all_tokens? true
21  |      require_token_presence_for_authentication? true
22  |    end
23  |
24  |    strategies do
25  |      magic_link do
26  |        identity_field :email
27  |        registration_enabled? true
28  |        require_interaction? true
29  |
30  |        sender Navatrack.Accounts.User.Senders.SendMagicLinkEmail
31  |      end
32  |    end
33  |  end
34  |
35  |  postgres do
36  |    table "users"
37  |    repo Navatrack.Repo
38  |  end
39  |
40  |  actions do
41  |    defaults [:read]
42  |
43  |    read :get_by_subject do
44  |      description "Get a user by the subject claim in a JWT"
45  |      argument :subject, :string, allow_nil?: false
46  |      get? true
47  |      prepare AshAuthentication.Preparations.FilterBySubject
48  |    end
49  |
50  |    read :get_by_email do
51  |      description "Looks up a user by their email"
52  |      get? true
53  |
54  |      argument :email, :ci_string do
55  |        allow_nil? false
56  |      end
57  |
58  |      filter expr(email == ^arg(:email))
59  |    end
60  |
61  |    create :sign_in_with_magic_link do
62  |      description "Sign in or register a user with magic link."
63  |
64  |      argument :token, :string do
65  |        description "The token from the magic link that was sent to the user"
66  |        allow_nil? false
67  |      end
68  |
69  |      upsert? true
70  |      upsert_identity :unique_email
71  |      upsert_fields [:email]
72  |
73  |      # Uses the information from the token to create or sign in the user
74  |      change AshAuthentication.Strategy.MagicLink.SignInChange
75  |
76  |      metadata :token, :string do
77  |        allow_nil? false
78  |      end
79  |    end
80  |
81  |    action :request_magic_link do
82  |      argument :email, :ci_string do
83  |        allow_nil? false
84  |      end
85  |
86  |      run AshAuthentication.Strategy.MagicLink.Request
87  |    end
88  |  end
89  |
90  |  policies do
91  |    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
92  |      authorize_if always()
93  |    end
94  |  end
95  |
96  |  attributes do
97  |    uuid_primary_key :id
98  |
99  |    attribute :email, :ci_string do
100 |      allow_nil? false
101 |      public? true
102 |    end
103 |  end
104 |
105 |  identities do
106 |    identity :unique_email, [:email]
107 |  end
108 |end
109 |


Create: lib/navatrack/accounts/user/senders/send_magic_link_email.ex

1  |defmodule Navatrack.Accounts.User.Senders.SendMagicLinkEmail do
2  |  @moduledoc """
3  |  Sends a magic link email
4  |  """
5  |
6  |  use AshAuthentication.Sender
7  |  use NavatrackWeb, :verified_routes
8  |
9  |  import Swoosh.Email
10 |  alias Navatrack.Mailer
11 |
12 |  @impl true
13 |  def send(user_or_email, token, _) do
14 |    # if you get a user, its for a user that already exists.
15 |    # if you get an email, then the user does not yet exist.
16 |
17 |    email =
18 |      case user_or_email do
19 |        %{email: email} -> email
20 |        email -> email
21 |      end
22 |
23 |    new()
24 |    # TODO: Replace with your email
25 |    |> from({"noreply", "noreply@example.com"})
26 |    |> to(to_string(email))
27 |    |> subject("Your login link")
28 |    |> html_body(body(token: token, email: email))
29 |    |> Mailer.deliver!()
30 |  end
31 |
32 |  defp body(params) do
33 |    # NOTE: You may have to change this to match your magic link acceptance URL.
34 |
35 |    """
36 |    <p>Hello, #{params[:email]}! Click this link to sign in:</p>
37 |    <p><a href="#{url(~p"/magic_link/#{params[:token]}")}">#{url(~p"/magic_link/#{params[:token]}")}</a></p>
38 |    """
39 |  end
40 |end
41 |


Update: lib/navatrack/application.ex

     ...|
23 23   |      NavatrackWeb.Endpoint,
24 24   |      {Absinthe.Subscription, NavatrackWeb.Endpoint},
25    - |      AshGraphql.Subscription.Batcher
   25 + |      AshGraphql.Subscription.Batcher,
   26 + |      {AshAuthentication.Supervisor, [otp_app: :navatrack]}
26 27   |    ]
27 28   |
     ...|


Update: lib/navatrack/repo.ex

     ...|
 6  6   |  def installed_extensions do
 7  7   |    # Add extensions here, and the migration generator will install them.
 8    - |    ["ash-functions"]
    8 + |    ["ash-functions", "citext"]
 9  9   |  end
10 10   |
     ...|


Create: lib/navatrack/secrets.ex

1  |defmodule Navatrack.Secrets do
2  |  use AshAuthentication.Secret
3  |
4  |  def secret_for(
5  |        [:authentication, :tokens, :signing_secret],
6  |        Navatrack.Accounts.User,
7  |        _opts,
8  |        _context
9  |      ) do
10 |    Application.fetch_env(:navatrack, :token_signing_secret)
11 |  end
12 |end
13 |


Create: lib/navatrack_web/auth_overrides.ex

1  |defmodule NavatrackWeb.AuthOverrides do
2  |  use AshAuthentication.Phoenix.Overrides
3  |
4  |  # configure your UI overrides here
5  |
6  |  # First argument to `override` is the component name you are overriding.
7  |  # The body contains any number of configurations you wish to override
8  |  # Below are some examples
9  |
10 |  # For a complete reference, see https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html
11 |
12 |  # override AshAuthentication.Phoenix.Components.Banner do
13 |  #   set :image_url, "https://media.giphy.com/media/g7GKcSzwQfugw/giphy.gif"
14 |  #   set :text_class, "bg-red-500"
15 |  # end
16 |
17 |  # override AshAuthentication.Phoenix.Components.SignIn do
18 |  #  set :show_banner, false
19 |  # end
20 |end
21 |


Create: lib/navatrack_web/controllers/auth_controller.ex

1  |defmodule NavatrackWeb.AuthController do
2  |  use NavatrackWeb, :controller
3  |  use AshAuthentication.Phoenix.Controller
4  |
5  |  def success(conn, activity, user, _token) do
6  |    return_to = get_session(conn, :return_to) || ~p"/"
7  |
8  |    message =
9  |      case activity do
10 |        {:confirm_new_user, :confirm} -> "Your email address has now been confirmed"
11 |        {:password, :reset} -> "Your password has successfully been reset"
12 |        _ -> "You are now signed in"
13 |      end
14 |
15 |    conn
16 |    |> delete_session(:return_to)
17 |    |> store_in_session(user)
18 |    # If your resource has a different name, update the assign name here (i.e :current_admin)
19 |    |> assign(:current_user, user)
20 |    |> put_flash(:info, message)
21 |    |> redirect(to: return_to)
22 |  end
23 |
24 |  def failure(conn, activity, reason) do
25 |    message =
26 |      case {activity, reason} do
27 |        {_,
28 |         %AshAuthentication.Errors.AuthenticationFailed{
29 |           caused_by: %Ash.Error.Forbidden{
30 |             errors: [%AshAuthentication.Errors.CannotConfirmUnconfirmedUser{}]
31 |           }
32 |         }} ->
33 |          """
34 |          You have already signed in another way, but have not confirmed your account.
35 |          You can confirm your account using the link we sent to you, or by resetting your password.
36 |          """
37 |
38 |        _ ->
39 |          "Incorrect email or password"
40 |      end
41 |
42 |    conn
43 |    |> put_flash(:error, message)
44 |    |> redirect(to: ~p"/sign-in")
45 |  end
46 |
47 |  def sign_out(conn, _params) do
48 |    return_to = get_session(conn, :return_to) || ~p"/"
49 |
50 |    conn
51 |    |> clear_session(:navatrack)
52 |    |> put_flash(:info, "You are now signed out")
53 |    |> redirect(to: return_to)
54 |  end
55 |end
56 |


Create: lib/navatrack_web/live_user_auth.ex

1  |defmodule NavatrackWeb.LiveUserAuth do
2  |  @moduledoc """
3  |  Helpers for authenticating users in LiveViews.
4  |  """
5  |
6  |  import Phoenix.Component
7  |  use NavatrackWeb, :verified_routes
8  |
9  |  # This is used for nested liveviews to fetch the current user.
10 |  # To use, place the following at the top of that liveview:
11 |  # on_mount {NavatrackWeb.LiveUserAuth, :current_user}
12 |  def on_mount(:current_user, _params, session, socket) do
13 |    {:cont, AshAuthentication.Phoenix.LiveSession.assign_new_resources(socket, session)}
14 |  end
15 |
16 |  def on_mount(:live_user_optional, _params, _session, socket) do
17 |    if socket.assigns[:current_user] do
18 |      {:cont, socket}
19 |    else
20 |      {:cont, assign(socket, :current_user, nil)}
21 |    end
22 |  end
23 |
24 |  def on_mount(:live_user_required, _params, _session, socket) do
25 |    if socket.assigns[:current_user] do
26 |      {:cont, socket}
27 |    else
28 |      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
29 |    end
30 |  end
31 |
32 |  def on_mount(:live_no_user, _params, _session, socket) do
33 |    if socket.assigns[:current_user] do
34 |      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
35 |    else
36 |      {:cont, assign(socket, :current_user, nil)}
37 |    end
38 |  end
39 |end
40 |

Update: lib/navatrack_web/router.ex

       ...|
  2   2   |  use NavatrackWeb, :router
  3   3   |
      4 + |  use AshAuthentication.Phoenix.Router
      5 + |
      6 + |  import AshAuthentication.Plug.Helpers
  4   7   |  import Backpex.Router
  5   8   |
  6   9   |  pipeline :graphql do
     10 + |    plug :load_from_bearer
     11 + |    plug :set_actor, :user
  7  12   |    plug AshGraphql.Plug
  8  13   |  end
       ...|
 15  20   |    plug :protect_from_forgery
 16  21   |    plug :put_secure_browser_headers
     22 + |    plug :load_from_session
 17  23   |  end
 18  24   |
 19  25   |  pipeline :api do
 20  26   |    plug :accepts, ["json"]
     27 + |    plug :load_from_bearer
     28 + |    plug :set_actor, :user
 21  29   |  end
 22  30   |
       ...|
 24  32   |    pipe_through :browser
 25  33   |    backpex_routes()
     34 + |    auth_routes AuthController, Navatrack.Accounts.User, path: "/auth"
     35 + |    sign_out_route AuthController
     36 + |
     37 + |    # Remove these if you'd like to use your own authentication views
     38 + |    sign_in_route register_path: "/register",
     39 + |                  reset_path: "/reset",
     40 + |                  auth_routes_prefix: "/auth",
     41 + |                  on_mount: [{NavatrackWeb.LiveUserAuth, :live_no_user}],
     42 + |                  overrides: [
     43 + |                    NavatrackWeb.AuthOverrides,
     44 + |                    AshAuthentication.Phoenix.Overrides.Default
     45 + |                  ]
     46 + |
     47 + |    # Remove this if you do not want to use the reset password feature
     48 + |    reset_route auth_routes_prefix: "/auth",
     49 + |                overrides: [
     50 + |                  NavatrackWeb.AuthOverrides,
     51 + |                  AshAuthentication.Phoenix.Overrides.Default
     52 + |                ]
     53 + |
     54 + |    # Remove this if you do not use the confirmation strategy
     55 + |    confirm_route Navatrack.Accounts.User, :confirm_new_user,
     56 + |      auth_routes_prefix: "/auth",
     57 + |      overrides: [NavatrackWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
     58 + |
     59 + |    # Remove this if you do not use the magic link strategy.
     60 + |    magic_sign_in_route(Navatrack.Accounts.User, :magic_link,
     61 + |      auth_routes_prefix: "/auth",
     62 + |      overrides: [NavatrackWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
     63 + |    )
 26  64   |  end
 27  65   |
     66 + |  scope "/", NavatrackWeb do
     67 + |    pipe_through :browser
     68 + |
     69 + |    ash_authentication_live_session :authenticated_routes do
     70 + |      # in each liveview, add one of the following at the top of the module:
     71 + |      #
     72 + |      # If an authenticated user must be present:
     73 + |      # on_mount {NavatrackWeb.LiveUserAuth, :live_user_required}
     74 + |      #
     75 + |      # If an authenticated user *may* be present:
     76 + |      # on_mount {NavatrackWeb.LiveUserAuth, :live_user_optional}
     77 + |      #
     78 + |      # If an authenticated user must *not* be present:
     79 + |      # on_mount {NavatrackWeb.LiveUserAuth, :live_no_user}
     80 + |    end
     81 + |  end
     82 + |
 28  83   |  scope "/api/json" do
 29  84   |    pipe_through [:api]
       ...|
```

</details>

Run:

```
mix ash.migrate
```

<details>
  <summary>Output</summary>

```stdout
Getting extensions in current project...
Running migration for AshPostgres.DataLayer...

09:16:37.549 [info] == Running 20250916080654 DemoElixirAshBackpex.Repo.Migrations.AddAuthenticationResourcesExtensions1.up/0 forward

09:16:37.551 [info] execute "CREATE EXTENSION IF NOT EXISTS \"citext\""

09:16:37.566 [info] == Migrated 20250916080654 in 0.0s

09:16:37.584 [info] == Running 20250916080656 DemoElixirAshBackpex.Repo.Migrations.AddAuthenticationResources.up/0 forward

09:16:37.584 [info] create table users

09:16:37.585 [info] create table tokens

09:16:37.586 [info] == Migrated 20250916080656 in 0.0s

09:16:37.587 [info] == Running 20250916081241 DemoElixirAshBackpex.Repo.Migrations.AddAuthenticationResourcesAndAddMagicLinkAuth.up/0 forward

09:16:37.587 [info] alter table users

09:16:37.587 [info] create index users_unique_email_index

09:16:37.588 [info] == Migrated 20250916081241 in 0.0s
```

</details>

Visit <http://localhost:4000/register>

You should see the Ash Framework logo, a form input for an email address, and a button that says "Request magic link".

Enter an email address.

You should see a toast "If the user is in our database, then they should receive an email shortly."

Because we generated our Phoenix project with mix phx.new, our project is automatically configured to use the development Swoosh mailer. To view notifier emails during development with Swoosh, navigate to /dev/mailbox.

Visit <http://localhost:4000/dev/mailbox>

You should see a mailbox user interface with your magic link email message.
