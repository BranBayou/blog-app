require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  it 'is valid with a name and posts_counter' do
    subject.name = 'John Doe'
    subject.posts_counter = 0
    expect(subject).to be_valid
  end

  it 'is invalid without a name' do
    subject.posts_counter = 0
    expect(subject).not_to be_valid
    expect(subject.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with a name shorter than 3 characters' do
    subject.name = 'Jo'
    subject.posts_counter = 0
    expect(subject).not_to be_valid
    expect(subject.errors[:name]).to include('is too short (minimum is 3 characters)')
  end

  it 'is invalid with a name longer than 50 characters' do
    subject.name = 'a' * 51
    subject.posts_counter = 0
    expect(subject).not_to be_valid
    expect(subject.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is valid with a non-negative integer posts_counter' do
    subject.name = 'John Doe'
    subject.posts_counter = 5
    expect(subject).to be_valid
  end

  it 'is invalid with a negative posts_counter' do
    subject.name = 'John Doe'
    subject.posts_counter = -1
    expect(subject).not_to be_valid
    expect(subject.errors[:posts_counter]).to include('must be greater than or equal to 0')
  end

  describe '#recent_posts' do
    let(:user) { create(:user) }

    it 'returns the 3 most recent posts' do
      post1 = create(:post, author: user, created_at: 1.day.ago)
      post2 = create(:post, author: user, created_at: 2.days.ago)
      post3 = create(:post, author: user, created_at: 3.days.ago)
      post4 = create(:post, author: user, created_at: 4.days.ago)

      expect(user.recent_posts).to eq([post1, post2, post3])
      expect(user.recent_posts).not_to include(post4)
    end
  end
end
