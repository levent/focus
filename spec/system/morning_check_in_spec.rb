require "rails_helper"

RSpec.describe "Morning check-in", type: :system do
  context "when no entry exists for today" do
    it "shows the morning form" do
      visit root_path

      expect(page).to have_text("What is your primary focus for today?")
      expect(page).to have_text("What blockers do you envisage?")
      expect(page).to have_button("Set today's focus")
    end

    it "creates an entry with focus and blockers and shows a confirmation" do
      visit root_path

      fill_in "What is your primary focus for today?", with: "Ship the morning UI"
      fill_in "What blockers do you envisage?", with: "Code review backlog"
      click_button "Set today's focus"

      expect(page).to have_text("Focus set for today")
      expect(FocusEntry.today.primary_focus).to eq("Ship the morning UI")
      expect(FocusEntry.today.anticipated_blockers).to eq("Code review backlog")
    end

    it "creates an entry without blockers (optional field)" do
      visit root_path

      fill_in "What is your primary focus for today?", with: "Ship the morning UI"
      click_button "Set today's focus"

      expect(page).to have_text("Focus set for today")
      expect(FocusEntry.today.anticipated_blockers).to be_nil
    end

    it "shows a validation error when primary focus is blank" do
      visit root_path

      click_button "Set today's focus"

      expect(page).to have_text("can't be blank")
      expect(FocusEntry.today).to be_nil
    end
  end

  context "when a morning entry already exists" do
    before { FocusEntry.create!(entry_date: Date.current, primary_focus: "Ship the morning UI") }

    it "does not show the morning form" do
      visit root_path

      expect(page).not_to have_button("Set today's focus")
    end
  end
end
