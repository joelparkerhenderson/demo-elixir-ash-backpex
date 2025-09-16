defmodule DemoElixirAshBackpexWeb.Admin.ItemLive do
  use AshBackpex.LiveResource

  backpex do
    resource(DemoElixirAshBackpex.MyDomain.Item)
    layout({DemoElixirAshBackpexWeb.Layouts, :admin})

    fields do
      field :name
      field :note
    end
  end
end
