defmodule TelecmsWeb.AuthViewTest do
  use TelecmsWeb.ConnCase, async: true

  import Phoenix.View

  test "renders index page" do
    rendered = render_to_string(TelecmsWeb.AuthView, "auth.html", [])
    assert rendered
  end

end
