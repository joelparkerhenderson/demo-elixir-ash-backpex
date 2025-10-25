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
