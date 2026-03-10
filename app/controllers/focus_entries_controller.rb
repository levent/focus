class FocusEntriesController < ApplicationController
  before_action :load_or_build_today_entry

  def show
  end

  def create
    if @entry.update(morning_params)
      redirect_to focus_entry_path, notice: "Focus set for today."
    else
      render :show, status: :unprocessable_content
    end
  end

  def update
    if @entry.update(evening_params)
      redirect_to focus_entry_path, notice: "End-of-day review saved."
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def load_or_build_today_entry
    @entry = FocusEntry.today || FocusEntry.new(entry_date: Date.current)
  end

  def morning_params
    params.require(:focus_entry).permit(:primary_focus, :anticipated_blockers)
  end

  def evening_params
    params.require(:focus_entry).permit(:achieved, :non_achievement_reason)
  end
end
