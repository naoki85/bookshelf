require 'features_helper'

describe '本の登録' do
  after do
    # 初期化
    BookRepository.new.clear
  end

  it '新しい本のレコードが作成される' do
    visit '/books/new'

    # id="book-form"であるformタグ内の
    within 'form#book-form' do
      # "Title"に"New book"を
      fill_in 'Title',  with: 'New book'
      # "Author"に"Some author"を入力して、
      fill_in 'Author', with: 'Some author'

      # "Create"ボタンを押す
      click_button 'Create'
    end

    # 現在のパスは/books（リダイレクトされる）
    current_path.must_equal('/books')
    # ページ内に"New book"という文字が含まれる
    assert page.has_content?('New book')
  end
end