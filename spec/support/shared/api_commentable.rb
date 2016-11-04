shared_examples_for "API Commentable" do |commentable|
  context 'comments' do
    it "included in #{commentable} object" do
      expect(response.body).to have_json_size(2).at_path("comments")
    end
    
    %w(id body created_at updated_at).each do |attr|
      it "Comments object contains #{attr}" do
        expect(response.body).to be_json_eql(comments.last.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
      end
    end
  end  
end