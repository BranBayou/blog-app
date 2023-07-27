require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  subject { described_class.new }

  it 'is valid with a title, comments_counter, and likes_counter' do
    subject.title = 'Test Post'
    subject.comments_counter = 0
    subject.likes_counter = 0
    subject.author = user
    expect(subject).to be_valid
  end

  it 'is invalid without a title' do
    subject.comments_counter = 0
    subject.likes_counter = 0
    subject.author = user
    expect(subject).not_to be_valid
    expect(subject.errors[:title]).to include("can't be blank")
  end

  it 'is invalid with a title shorter than 2 characters' do
    subject.title = 'A'
    subject.comments_counter = 0
    subject.likes_counter = 0
    subject.author = user
    expect(subject).not_to be_valid
    expect(subject.errors[:title]).to include('is too short (minimum is 2 characters)')
  end

  it 'is invalid with a title longer than 250 characters' do
    subject.title = 'a' * 251
    subject.comments_counter = 0
    subject.likes_counter = 0
    subject.author = user
    expect(subject).not_to be_valid
    expect(subject.errors[:title]).to include('is too long (maximum is 250 characters)')
  end

  it 'is valid with a non-negative integer comments_counter' do
    subject.title = 'Test Post'
    subject.comments_counter = 5
    subject.likes_counter = 0
    subject.author = user
    expect(subject).to be_valid
  end

  it 'is invalid with a negative comments_counter' do
    subject.title = 'Test Post'
    subject.comments_counter = -1
    subject.likes_counter = 0
    subject.author = user
    expect(subject).not_to be_valid
    expect(subject.errors[:comments_counter]).to include('must be greater than or equal to 0')
  end

  it 'is valid with a non-negative integer likes_counter' do
    subject.title = 'Test Post'
    subject.comments_counter = 0
    subject.likes_counter = 10
    subject.author = user
    expect(subject).to be_valid
  end

  it 'is invalid with a negative likes_counter' do
    subject.title = 'Test Post'
    subject.comments_counter = 0
    subject.likes_counter = -1
    subject.author = user
    expect(subject).not_to be_valid
    expect(subject.errors[:likes_counter]).to include('must be greater than or equal to 0')
  end

  describe '#recent_comments' do
    let(:post) { create(:post, author: user) }

    it 'returns the 5 most recent comments' do
      comment1 = create(:comment, post: post, created_at: 1.day.ago)
      comment2 = create(:comment, post: post, created_at: 2.days.ago)
      comment3 = create(:comment, post: post, created_at: 3.days.ago)
      comment4 = create(:comment, post: post, created_at: 4.days.ago)
      comment5 = create(:comment, post: post, created_at: 5.days.ago)
      comment6 = create(:comment, post: post, created_at: 6.days.ago)

      expect(post.recent_comments).to eq([comment1, comment2, comment3, comment4, comment5])
      expect(post.recent_comments).not_to include(comment6)
    end
  end

  describe '#update_posts_counter' do
    it 'increases the author posts_counter by 1' do
      post = create(:post, author: user)
      expect { post.save }.to change { user.reload.posts_counter }.by(1)
    end
  end
end
