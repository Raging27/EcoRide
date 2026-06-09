module TripsHelper
  TRIP_STATUS_LABELS = {
    "planned"     => { label: "Planifié",  css: "bg-success" },
    "in_progress" => { label: "En cours",  css: "bg-warning text-dark" },
    "finished"    => { label: "Terminé",   css: "bg-secondary" }
  }.freeze

  def trip_status_badge(status)
    config = TRIP_STATUS_LABELS[status] || { label: status, css: "bg-light text-dark" }
    content_tag(:span, config[:label], class: "badge #{config[:css]}")
  end
end
