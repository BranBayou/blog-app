require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { should belong_to(:user).with_foreign_key(:author_id) }
    it { should belong_to(:post) }
  end

  describe 'callbacks' do
    context 'after_save' do
      let(:user) { FactoryBot.create(:user) }
      let(:post) { FactoryBot.create(:post) }
    end
  end
end
