require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/index'

describe Web::Controllers::Books::Index do
  # actionにBooks#Indexのインスタンスをセット
  let(:action) { Web::Controllers::Books::Index.new }
  # パラメーター（今回は何もない）
  let(:params) { Hash[] }
  # BookRepositoryをセット
  let(:repository) { BookRepository.new }

  before do
    repository.clear

    @book = repository.create(title: 'TDD', author: 'Kent Beck')
  end

  it 'ステータスコードの200番が返る' do
    response = action.call(params)
    response[0].must_equal 200
  end

  it '全てのbooksがexposureによって渡されている' do
    action.call(params)
    action.exposures[:books].must_equal [@book]
  end
end
