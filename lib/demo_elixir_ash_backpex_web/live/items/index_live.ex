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
    {:noreply,
     socket
     |> assign(:page_title, "Items")
     |> assign(:items, X |> Ash.Query.for_read(:read) |> Ash.read!())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@page_title}
        <:actions>
          <.button navigate={~p"/items/new"}>
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
