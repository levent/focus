require "rails_helper"

RSpec.describe "History", type: :request do
  describe "GET /history" do
    it "returns 200" do
      get history_path
      expect(response).to have_http_status(:ok)
    end

    it "only shows reviewed entries" do
      FocusEntry.create!(entry_date: 2.days.ago, primary_focus: "Reviewed task", achieved: true)
      FocusEntry.create!(entry_date: 1.day.ago, primary_focus: "Unreviewed task")

      get history_path
      expect(response.body).to include("Reviewed task")
      expect(response.body).not_to include("Unreviewed task")
    end

    it "paginates results" do
      31.times do |i|
        FocusEntry.create!(entry_date: (i + 1).days.ago, primary_focus: "Task #{i}", achieved: true)
      end

      get history_path
      expect(response.body).to include("Older")
      expect(response.body).not_to include("Newer")

      get history_path(page: 2)
      expect(response.body).to include("Newer")
      expect(response.body).not_to include("Older")
    end
  end
end
