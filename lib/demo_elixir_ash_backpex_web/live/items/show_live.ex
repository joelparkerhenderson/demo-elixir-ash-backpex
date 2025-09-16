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
     |> assign(:item, item)}
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
          <.button navigate={~p"/items/#{@item.id}/edit"}>
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
         |> push_navigate(to: ~p"/items")}

      {:error, error} ->
        Logger.warning("Delete failed for item '#{id}':
          #{inspect(error)}")

        {:noreply,
         socket
         |> put_flash(:error, "Delete failed.")}
    end
  end
end
