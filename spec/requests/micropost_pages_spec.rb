require 'spec_helper'

describe "MicropostPages" do
  
  subject { page } 
  let(:user) { FactoryGirl.create(:user)}
  let(:otheruser) { FactoryGirl.create(:user) }
  before {sign_in user}

  describe "micropost creation" do
  	before {visit root_path}
  	
  	describe "with invalid information" do

  		it "should not create a new micropost" do
  			expect { click_button 'Post' }.not_to change(Micropost, :count)
  		end
  		describe "should show error message" do
  			before {click_button 'Post'}
  			it { should have_content('error') }  			
  		end
  	end

  	describe "with valid information" do
  		before do
  			fill_in 'micropost_content', with: "Lorem ipsum"
			end
      it "should create a new micropost" do
         expect { click_button "Post" }.to change(Micropost, :count).by(1)        
      end
  	end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")}
    describe "as the correct user" do
      before {visit root_path}
      it "should delete the micropost" do
        expect { click_link "Delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "pagination" do
    before do
      31.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    it { should have_selector("div.pagination") }
  end

  describe "pluralisation" do
    describe "of the first post" do
      before do
        FactoryGirl.create(:micropost, user: user)
        visit root_path
      end
      it { should have_selector("span", text: "1 micropost") }
    end
    describe "of the second post" do
      before do
        2.times {FactoryGirl.create(:micropost, user: user)}
        visit root_path
      end
      it { should have_selector("span", text: "2 microposts") }
    end    
  end

  describe "delete links for other user don't appear" do
    let(:theirpost) {FactoryGirl.create(:micropost, user: otheruser) }
    before do
      visit user_path(otheruser)
    end
    it { should_not have_link "Delete" }
  end
end