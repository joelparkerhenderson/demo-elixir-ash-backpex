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
