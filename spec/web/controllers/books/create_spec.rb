require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/create'

describe Web::Controllers::Books::Create do
  # actionにbooks#createをセット
  let(:action) { Web::Controllers::Books::Create.new }
  # BookRepositoryをセット
  let(:repository) { BookRepository.new }

  before do
    repository.clear
  end

  describe '有効なパラメーターであれば' do
    let(:params) { Hash[book: { title: 'Confident Ruby', author: 'Avdi Grimm' }] }

    it '本が登録される' do
      # パラメーターを渡してアクションを呼ぶ（登録処理がされる）
      action.call(params)
      # booksテーブルから最後に登録されたレコードを取得
      book = repository.last

      # 取得した値がパラメーターと一致しているか確認
      book.id.wont_be_nil
      book.title.must_equal params.dig(:book, :title)
    end

    it '登録処理が終わったら、一覧へリダイレクトされている' do
      response = action.call(params)

      # ステータスコードは302（リダイレクト）が返る
      response[0].must_equal 302
      # リダイレクト先は/booksであること
      response[1]['Location'].must_equal '/books'
    end
  end

  describe '無効なパラメーターであれば' do
    let(:params) { Hash[book: {}] }

    it 'HTTPエラーコードが返る' do
      response = action.call(params)
      response[0].must_equal 422
    end

    it '返却値にエラーが含まれる' do
      action.call(params)
      errors = action.params.errors

      errors.dig(:book, :title).must_equal  ['is missing']
      errors.dig(:book, :author).must_equal ['is missing']
    end
  end
end