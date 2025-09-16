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

  live_session :default, on_mount: Backpex.InitAssigns do
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
