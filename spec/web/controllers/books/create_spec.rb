require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/create'

describe Web::Controllers::Books::Create do
  # actionにbooks#createをセット
  let(:action) { Web::Controllers::Books::Create.new }
  # 渡すパラメーター（今回は登録する値をハッシュで）
  let(:params) { Hash[book: { title: 'Confident Ruby', author: 'Avdi Grimm' }] }
  # BookRepositoryをセット
  let(:repository) { BookRepository.new }

  before do
    repository.clear
  end

  it '本の新規登録をする' do
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