require "rails_helper"

RSpec.describe "History", type: :system do
  context "with past reviewed entries" do
    before do
      FocusEntry.create!(entry_date: 2.days.ago, primary_focus: "First task", achieved: true)
      FocusEntry.create!(entry_date: 1.day.ago, primary_focus: "Second task", achieved: false, non_achievement_reason: "Got blocked")
    end

    it "displays past entries in reverse chronological order" do
      visit history_path

      entries = page.all("h2.text-xl").map(&:text)
      first_date = 1.day.ago.to_date.strftime("%A, %-d %B %Y")
      second_date = 2.days.ago.to_date.strftime("%A, %-d %B %Y")

      expect(entries).to eq([ "History", first_date, second_date ])
    end

    it "navigates from main page to history and back" do
      visit root_path
      click_link "History"

      expect(page).to have_text("History")
      expect(page).to have_text("First task")

      click_link "Back to today"
      expect(page).to have_current_path(root_path)
    end
  end

  context "with no reviewed entries" do
    it "shows empty state" do
      visit history_path
      expect(page).to have_text("No completed entries yet.")
    end
  end
end
