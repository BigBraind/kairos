defmodule LifecycleWeb.Modal.Function.Pubsub.PhasePubs do
  @moduledoc """
  Handler pubsubs for phase object being craeted, edited and deleted
  """
  use Phoenix.Component

  alias Lifecycle.Timeline

  @doc """
  Notify other users who subscribe to phase index that new phase been created
  so that they dont lose ph(f)as(c)e
  """
  def handle_phase_created(socket, _message) do
    {:noreply, assign(socket, phases: Timeline.list_phases())}
  end

  @doc """
  Notify other users on the phase being edited
  """
  def handle_phase_edited(socket, _message) do
    {:noreply, assign(socket, phases: Timeline.list_phases())}
  end

  @doc """
  Notify other users on the phase being deleted
  """
  def handle_phase_deleted(socket, _message) do
    {:noreply, assign(socket, phases: Timeline.list_phases())}
  end
end
