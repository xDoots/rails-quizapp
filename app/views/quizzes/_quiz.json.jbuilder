json.extract! quiz, :id, :title, :description, :user_id, :public, :created_at, :updated_at
json.url quiz_url(quiz, format: :json)
