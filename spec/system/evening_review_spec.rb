require "rails_helper"

RSpec.describe "Evening review", type: :system do
  before do
    FocusEntry.create!(
      entry_date: Date.current,
      primary_focus: "Ship the evening UI",
      anticipated_blockers: "Interruptions"
    )
  end

  context "when a morning entry exists but has not been reviewed" do
    it "shows the evening form with today's focus" do
      visit root_path

      expect(page).to have_text("How did today go?")
      expect(page).to have_text("Ship the evening UI")
      expect(page).to have_button("Save review")
    end

    it "does not show the morning form" do
      visit root_path

      expect(page).not_to have_button("Set today's focus")
    end
  end

  context "marking the goal as achieved" do
    it "saves the review and shows the summary" do
      visit root_path

      find("label", text: "Yes").click
      click_button "Save review"

      expect(page).to have_text("End-of-day review saved")
      expect(page).to have_text("Today's summary")
      expect(page).to have_text("Achieved")
      expect(FocusEntry.today.achieved).to be true
    end
  end

  context "marking the goal as not achieved" do
    it "reveals the reason field when No is selected" do
      visit root_path

      find("label", text: "No").click

      expect(page).to have_field("What got in the way?")
    end

    it "saves the review with a reason and shows the summary" do
      visit root_path

      find("label", text: "No").click
      fill_in "What got in the way?", with: "Got pulled into production incidents"
      click_button "Save review"

      expect(page).to have_text("End-of-day review saved")
      expect(page).to have_text("Today's summary")
      expect(page).to have_text("Not achieved")
      expect(page).to have_text("Got pulled into production incidents")

      entry = FocusEntry.today
      expect(entry.achieved).to be false
      expect(entry.non_achievement_reason).to eq("Got pulled into production incidents")
    end

    it "shows a validation error when no reason is given" do
      visit root_path

      find("label", text: "No").click
      click_button "Save review"

      expect(page).to have_text("can't be blank")
      expect(FocusEntry.today.reviewed?).to be false
    end
  end
end
