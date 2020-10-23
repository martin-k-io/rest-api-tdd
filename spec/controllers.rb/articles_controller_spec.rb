require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#index' do
    subject { get :index }

    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok) #200
    end

    it 'should return proper json' do
      articles = create_list :article, 2 #factorybot method
      subject
      
      articles.each_with_index do |article, index |
        expect(json_data[index]['attributes']).to eq({
          "title" => article.title,
          "content" => article.content,
          "slug" => article.slug
        })
      end
    end
  end
end