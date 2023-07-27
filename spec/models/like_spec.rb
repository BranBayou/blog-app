require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { should belong_to(:user).with_foreign_key(:author_id) }
    it { should belong_to(:post) }
  end

  describe 'callbacks' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    context 'after_save' do
      it 'updates the likes_counter after saving a like' do
        expect(post.likes_counter).to eq(0)

        new_like = build(:like, post: post, user: user)
        new_like.save

        expect(post.reload.likes_counter).to eq(1)
      end
    end
  end
end
