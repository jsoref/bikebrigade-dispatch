defmodule BikeBrigadeWeb.CalendarLive.Index do
  use BikeBrigadeWeb, {:live_view, layout: {BikeBrigadeWeb.LayoutView, "public.live.html"}}

  alias BikeBrigade.Utils
  alias BikeBrigade.Delivery
  alias BikeBrigade.LocalizedDateTime

  alias BikeBrigadeWeb.DeliveryHelpers

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket) do
    #  Delivery.subscribe()
    # end

    start_date =  LocalizedDateTime.today()
    opportunities = list_opportunities(start_date)

    end_date = case List.last(opportunities) do
      {end_date, _} -> end_date
      nil -> start_date
    end

    {:ok,
     socket
     |> assign(:start_date, start_date)
     |> assign(:end_date, end_date)
     |> assign(:opportunities, list_opportunities(start_date))}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:expanded, nil)
  # end

  # defp apply_action(socket, :show, %{"id" => id}) do
  #   socket
  #   |> assign(:expanded, String.to_integer(id))
  # end

  def list_opportunities(start_date) do
    Delivery.list_opportunities(start_date: start_date, published: true)
    |> Utils.ordered_group_by(&LocalizedDateTime.to_date(&1.delivery_start))
  end
end
