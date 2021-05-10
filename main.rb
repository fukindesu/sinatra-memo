# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

APP_NAME = 'メモアプリ'

before do
  @memos = load_memos
end

helpers do
  def load_memos
    memos = []
    Dir.glob('storages/*') do |file|
      memos << JSON.parse(File.read(file))
    end
    memos.sort_by { |memo| memo['id'] }
  end

  def find_memo(memos, params)
    memos.find { |memo| memo['id'].to_s == params['id'] }
  end

  def build_page_title(page_title)
    [page_title, APP_NAME].compact.join(' | ')
  end
end

get '/' do
  redirect '/memos'
end

get '/memos/?' do
  @page_title = build_page_title(nil)
  erb :index
end

get '/memos/new/?' do
  @page_title = build_page_title('メモの作成')
  @memo = { 'id' => '', 'title' => '', 'body' => '' }
  erb :edit
end

get '/memos/:id/?' do
  if (@memo = find_memo(@memos, params))
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
    erb :error
  end
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo(@memos, params))
    @page_title = build_page_title('メモの変更')
    erb :edit
  else
    status 404
    erb :error
  end
end

get '/*' do
  @page_title = build_page_title('ページが見つかりませんでした')
  status 404
  erb :error
end
