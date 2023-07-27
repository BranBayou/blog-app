require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:author).class_name('User').with_foreign_key(:author_id) }
    it { should belong_to(:post) }
  end

  describe 'callbacks' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    context 'after_save' do
      it 'updates the comments_counter after saving a comment' do
        expect(post.comments_counter).to eq(0)

        new_comment = build(:comment, post: post, author: user)
        new_comment.save

        expect(post.reload.comments_counter).to eq(1)
      end
    end
  end
end
