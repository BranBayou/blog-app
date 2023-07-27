require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  subject(:post) do
    described_class.new(
      title: 'Test Post',
      comments_counter: 0,
      likes_counter: 0,
      author: user
    )
  end

  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(2).is_at_most(250) }
    it { should validate_presence_of(:comments_counter) }
    it { should validate_numericality_of(:comments_counter).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:likes_counter) }
    it { should validate_numericality_of(:likes_counter).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'after_save :update_posts_counter' do
    it 'updates the posts_counter of the author after saving' do
      expect { post.save }.to change { user.reload.posts_counter }.by(1)
    end
  end
end
