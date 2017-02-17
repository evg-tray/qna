RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }

  describe 'methods' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:question_another_user) { create(:question) }
    let!(:answer) { create(:answer, user: user) }
    let!(:answer_another_user) { create(:answer) }
    let!(:voted_question) { create(:question) }
    let!(:vote_question) { create(:vote, user: user, votable: voted_question) }
    let!(:vote_question_another_user) { create(:vote, votable: voted_question) }
    let!(:voted_answer) { create(:answer) }
    let!(:vote_answer) { create(:vote, user: user, votable: voted_answer) }
    let!(:vote_answer_another_user) { create(:vote, votable: voted_answer) }

    context 'author of' do
      context 'question' do
        it 'return true if user is an author of question' do
          expect(user.author_of?(question)).to eq true
        end

        it 'return false if user is not an author of question' do
          expect(user.author_of?(question_another_user)).to eq false
        end
      end

      context 'answer' do
        it 'return true if user is an author of question' do
          expect(user.author_of?(answer)).to eq true
        end
        it 'return false if user is not an author of question' do
          expect(user.author_of?(answer_another_user)).to eq false
        end
      end
    end

    context 'voted of' do
      context 'question' do
        it 'return true if user voted to question' do
          expect(user.voted_of?(voted_question)).to eq true
        end

        it 'return false if user not voted to question' do
          expect(user.voted_of?(question_another_user)).to eq false
        end
      end

      context 'answer' do
        it 'return true if user voted to answer' do
          expect(user.voted_of?(voted_answer)).to eq true
        end

        it 'return false if user not voted to answer' do
          expect(user.voted_of?(answer_another_user)).to eq false
        end
      end
    end

    context 'find vote' do
      context 'question' do
        it 'return Vote if user voted to question' do
          expect(user.find_vote(voted_question)).to eq vote_question
        end

        it 'return nil if user not voted to question' do
          expect(user.find_vote(question_another_user)).to eq nil
        end
      end

      context 'answer' do
        it 'return Vote if user voted to answer' do
          expect(user.find_vote(voted_answer)).to eq vote_answer
        end

        it 'return nil if user not voted to answer' do
          expect(user.find_vote(answer_another_user)).to eq nil
        end
      end
    end

    context 'from_omniauth' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '123456')
          expect(User.from_omniauth(auth)).to eq user
        end
      end

      context 'user has not authorization' do
        context 'provider received email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

          context 'user already exists' do
            it 'does not create new user' do
              expect { User.from_omniauth(auth) }.to_not change(User, :count)
            end

            it 'creates authorization for user' do
              expect { User.from_omniauth(auth) }.to change(user.authorizations, :count).by(1)
            end

            it 'creates authorization with provider and uid' do
              authorization = User.from_omniauth(auth).authorizations.first

              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end

            it 'returns the user with verified email' do
              expect(User.from_omniauth(auth)).to eq user
              expect(user.email_verified?).to eq true
            end
          end

          context 'user does not exist' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: Faker::Internet.email }) }

            it 'creates new user' do
              expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
            end

            it 'returns new user' do
              expect(User.from_omniauth(auth)).to be_a(User)
            end

            it 'fills user email' do
              user = User.from_omniauth(auth)
              expect(user.email).to eq auth.info[:email]
            end

            it 'creates authorization for user' do
              user = User.from_omniauth(auth)
              expect(user.authorizations).to_not be_empty
            end

            it 'creates authorization with provider and uid' do
              authorization = User.from_omniauth(auth).authorizations.first

              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end
          end
        end

        context 'provider not received email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

          context 'user already exists with authorization and temporary email' do
            let!(:user) { create(:user, email: 'temp-123456@temp.com') }
            before { user.authorizations.create(provider: 'facebook', uid: '123456') }

            it 'does not create new user' do
              expect { User.from_omniauth(auth) }.to_not change(User, :count)
            end

            it 'not create authorization for user' do
              expect { User.from_omniauth(auth) }.not_to change(user.authorizations, :count)
            end

            it 'returns the user with not verified email' do
              expect(User.from_omniauth(auth)).to eq user
              expect(user.email_verified?).to eq false
            end
          end

          context 'user does not exist' do
            it 'creates new user' do
              expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
            end

            it 'returns new user' do
              expect(User.from_omniauth(auth)).to be_a(User)
            end

            it 'fills user email with temporary email' do
              user = User.from_omniauth(auth)
              expect(user.email).to eq "temp-#{auth.uid}@temp.com"
            end

            it 'creates authorization for user' do
              user = User.from_omniauth(auth)
              expect(user.authorizations).to_not be_empty
            end

            it 'creates authorization with provider and uid' do
              authorization = User.from_omniauth(auth).authorizations.first

              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end

            it 'returned user have not verified email' do
              user = User.from_omniauth(auth)
              expect(user.email_verified?).to eq false
            end
          end
        end


      end
    end

    context 'email_verified?' do
      it 'return true if user`s mail is not temporary' do
        expect(user.email_verified?).to eq true
      end
      it 'return false if user`s mail is temporary' do
        user.email = 'temp-123123@temp.com'
        expect(user.email_verified?).to eq false
      end
    end

    context 'has_token?' do
      let(:authorization) { create(:authorization, user: user) }

      it 'return true if user has verify token to update account' do
        create(:omnitoken, user: user, authorization: authorization)
        expect(user.has_token?(authorization)).to eq true
      end
      it 'return false if user has not verify token to update account' do
        expect(user.has_token?(authorization)).to eq false
      end
    end
  end
end
