require "rails_helper"

RSpec.describe "FocusEntries", type: :request do
  describe "GET /focus_entry" do
    context "when no entry exists for today" do
      it "returns 200" do
        get focus_entry_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a morning entry exists but is unreviewed" do
      before { FocusEntry.create!(entry_date: Date.current, primary_focus: "Ship it") }

      it "returns 200" do
        get focus_entry_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when today's entry has been reviewed" do
      before { FocusEntry.create!(entry_date: Date.current, primary_focus: "Ship it", achieved: true) }

      it "returns 200" do
        get focus_entry_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /focus_entry" do
    context "with valid morning params" do
      it "creates an entry and redirects" do
        expect {
          post focus_entry_path, params: { focus_entry: { primary_focus: "Ship the feature", anticipated_blockers: "Meetings" } }
        }.to change(FocusEntry, :count).by(1)

        expect(response).to redirect_to(focus_entry_path)
      end
    end

    context "with missing primary_focus" do
      it "does not create an entry and returns unprocessable_entity" do
        expect {
          post focus_entry_path, params: { focus_entry: { primary_focus: "" } }
        }.not_to change(FocusEntry, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /focus_entry" do
    context "with achieved: true" do
      before { FocusEntry.create!(entry_date: Date.current, primary_focus: "Ship it") }

      it "updates the entry and redirects" do
        patch focus_entry_path, params: { focus_entry: { achieved: true } }

        expect(FocusEntry.today.achieved).to be true
        expect(response).to redirect_to(focus_entry_path)
      end
    end

    context "with achieved: false and a reason" do
      before { FocusEntry.create!(entry_date: Date.current, primary_focus: "Ship it") }

      it "updates the entry and redirects" do
        patch focus_entry_path, params: { focus_entry: { achieved: false, non_achievement_reason: "Got pulled into incidents" } }

        entry = FocusEntry.today
        expect(entry.achieved).to be false
        expect(entry.non_achievement_reason).to eq("Got pulled into incidents")
        expect(response).to redirect_to(focus_entry_path)
      end
    end

    context "with achieved: false and no reason" do
      before { FocusEntry.create!(entry_date: Date.current, primary_focus: "Ship it") }

      it "does not update and returns unprocessable_entity" do
        patch focus_entry_path, params: { focus_entry: { achieved: false, non_achievement_reason: "" } }

        expect(FocusEntry.today.achieved).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
