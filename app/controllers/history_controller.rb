class HistoryController < ApplicationController
  PER_PAGE = 30

  def show
    page = [ params[:page].to_i, 1 ].max
    offset = (page - 1) * PER_PAGE

    entries = FocusEntry.reviewed.recent.offset(offset).limit(PER_PAGE + 1).to_a

    @has_next_page = entries.size > PER_PAGE
    @entries = entries.first(PER_PAGE)
    @page = page
  end
end
