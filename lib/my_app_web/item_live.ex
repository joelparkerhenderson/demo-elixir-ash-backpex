defmodule MyAppWeb.ItemLive do
  use AshBackpex.LiveResource

  backpex do
    resource MyApp.MyDomain.Item
    layout &MyAppWeb.Layouts.admin/1

    fields do
      field :name, module: Backpex.Fields.Text
      field :note, module: Backpex.Fields.Text
    end
  end

end
