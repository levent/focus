require "rails_helper"

RSpec.describe FocusEntry, type: :model do
  describe "validations" do
    it "is valid with entry_date and primary_focus" do
      entry = FocusEntry.new(entry_date: Date.current, primary_focus: "Ship the focus feature")
      expect(entry).to be_valid
    end

    it "is invalid without entry_date" do
      entry = FocusEntry.new(primary_focus: "Ship the focus feature")
      expect(entry).not_to be_valid
      expect(entry.errors[:entry_date]).to be_present
    end

    it "is invalid without primary_focus" do
      entry = FocusEntry.new(entry_date: Date.current)
      expect(entry).not_to be_valid
      expect(entry.errors[:primary_focus]).to be_present
    end

    it "is invalid when entry_date is not unique" do
      FocusEntry.create!(entry_date: Date.current, primary_focus: "First entry")
      duplicate = FocusEntry.new(entry_date: Date.current, primary_focus: "Second entry")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:entry_date]).to be_present
    end

    it "requires non_achievement_reason when achieved is false" do
      entry = FocusEntry.new(entry_date: Date.current, primary_focus: "Ship the focus feature", achieved: false)
      expect(entry).not_to be_valid
      expect(entry.errors[:non_achievement_reason]).to be_present
    end

    it "does not require non_achievement_reason when achieved is true" do
      entry = FocusEntry.new(entry_date: Date.current, primary_focus: "Ship the focus feature", achieved: true)
      expect(entry).to be_valid
    end

    it "does not require non_achievement_reason when achieved is nil" do
      entry = FocusEntry.new(entry_date: Date.current, primary_focus: "Ship the focus feature", achieved: nil)
      expect(entry).to be_valid
    end
  end

  describe "scopes" do
    let!(:today_entry) { FocusEntry.create!(entry_date: Date.current, primary_focus: "Today's focus") }
    let!(:yesterday_entry) { FocusEntry.create!(entry_date: Date.yesterday, primary_focus: "Yesterday's focus", achieved: true) }
    let!(:unreviewed_entry) { FocusEntry.create!(entry_date: 2.days.ago.to_date, primary_focus: "Two days ago") }

    describe ".for_date" do
      it "returns the entry for the given date" do
        expect(FocusEntry.for_date(Date.current)).to eq(today_entry)
      end

      it "returns nil when no entry exists for the date" do
        expect(FocusEntry.for_date(10.days.ago.to_date)).to be_nil
      end
    end

    describe ".today" do
      it "returns the entry for today" do
        expect(FocusEntry.today).to eq(today_entry)
      end
    end

    describe ".reviewed" do
      it "returns only entries with a non-nil achieved value" do
        expect(FocusEntry.reviewed).to contain_exactly(yesterday_entry)
      end
    end

    describe ".unreviewed" do
      it "returns only entries where achieved is nil" do
        expect(FocusEntry.unreviewed).to contain_exactly(today_entry, unreviewed_entry)
      end
    end

    describe ".recent" do
      it "returns entries in descending date order" do
        expect(FocusEntry.recent).to eq([ today_entry, yesterday_entry, unreviewed_entry ])
      end
    end
  end

  describe "#morning_complete?" do
    it "returns true when primary_focus is present" do
      entry = FocusEntry.new(primary_focus: "Ship the focus feature")
      expect(entry.morning_complete?).to be true
    end

    it "returns false when primary_focus is blank" do
      entry = FocusEntry.new(primary_focus: nil)
      expect(entry.morning_complete?).to be false
    end
  end

  describe "#reviewed?" do
    it "returns false when achieved is nil" do
      entry = FocusEntry.new(achieved: nil)
      expect(entry.reviewed?).to be false
    end

    it "returns true when achieved is true" do
      entry = FocusEntry.new(achieved: true)
      expect(entry.reviewed?).to be true
    end

    it "returns true when achieved is false" do
      entry = FocusEntry.new(achieved: false)
      expect(entry.reviewed?).to be true
    end
  end
end
