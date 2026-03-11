require "rails_helper"

RSpec.describe "Summary view", type: :system do
  context "when today's entry has been reviewed as achieved" do
    before do
      FocusEntry.create!(
        entry_date: Date.current,
        primary_focus: "Ship the summary view",
        anticipated_blockers: "Code review delays",
        achieved: true
      )
    end

    it "shows the summary with all fields" do
      visit root_path

      expect(page).to have_text("Today's summary")
      expect(page).to have_text("Ship the summary view")
      expect(page).to have_text("Code review delays")
      expect(page).to have_text("Achieved")
    end

    it "does not show the morning or evening forms" do
      visit root_path

      expect(page).not_to have_button("Set today's focus")
      expect(page).not_to have_button("Save review")
    end
  end

  context "when today's entry has been reviewed as not achieved" do
    before do
      FocusEntry.create!(
        entry_date: Date.current,
        primary_focus: "Ship the summary view",
        achieved: false,
        non_achievement_reason: "Blocked by dependency"
      )
    end

    it "shows the not achieved outcome and reason" do
      visit root_path

      expect(page).to have_text("Not achieved")
      expect(page).to have_text("Blocked by dependency")
    end
  end

  context "when an ai_reflection is present" do
    before do
      FocusEntry.create!(
        entry_date: Date.current,
        primary_focus: "Ship the summary view",
        achieved: true,
        ai_reflection: "Great focus today. You avoided the usual distractions."
      )
    end

    it "shows the reflection" do
      visit root_path

      expect(page).to have_text("Reflection")
      expect(page).to have_text("Great focus today.")
    end
  end
end
