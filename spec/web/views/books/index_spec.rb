require 'spec_helper'
require_relative '../../../../apps/web/views/books/index'

describe Web::Views::Books::Index do
  # コントローラーからbooksの空配列が渡されると仮定
  let(:exposures) { Hash[books: []] }
  # 表示するテンプレートを指定
  let(:template)  { Hanami::View::Template.new('apps/web/templates/books/index.html.erb') }
  # Web::Views::Books::Indexの第一引数で表示するtemplate、第二引数にコントローラーから渡される値
  let(:view)      { Web::Views::Books::Index.new(template, exposures) }
  # Web::Views::Books::Indexの第一引数で表示するtemplate、第二引数にコントローラーから渡される値
  let(:rendered)  { view.render }
  # 上のビューインスタンスをレンダリング
  it 'view.booksとコントローラーから渡されたbooksが等しいことを確認' do
    view.books.must_equal exposures.fetch(:books)
  end

  describe 'booksが空の場合' do
    it 'プレースホルダーメッセージが表示される' do
      rendered.must_include('<p class="placeholder">There are no books yet.</p>')
    end
  end

  describe 'booksに値がある場合' do
    let(:book1)     { Book.new(title: 'Refactoring', author: 'Martin Fowler') }
    let(:book2)     { Book.new(title: 'Domain Driven Design', author: 'Eric Evans') }
    let(:exposures) { Hash[books: [book1, book2]] }

    it '全て表示される' do
      rendered.scan(/class="book"/).count.must_equal 2
      rendered.must_include('Refactoring')
      rendered.must_include('Domain Driven Design')
    end

    it 'プレースホルダーメッセージは表示されない' do
      rendered.wont_include('<p class="placeholder">There are no books yet.</p>')
    end
  end
end