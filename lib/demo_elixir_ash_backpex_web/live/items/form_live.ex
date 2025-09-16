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
         |> push_navigate(to: ~p"/items/#{item}")}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Save failed.")
         |> assign(:form, form)}
    end
  end
end
