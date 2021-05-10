# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

APP_NAME = 'メモアプリ'

helpers do
  def load_memos_from_directory
    memos = []
    Dir.glob('memo_files/*') do |file|
      memos << JSON.parse(File.read(file))
    end
    memos.sort_by { |memo| memo['id'] }
  end

  def find_memo
    memos = load_memos_from_directory
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
  @memos = load_memos_from_directory
  @page_title = build_page_title(nil)
  erb :index
end

get '/memos/new/?' do
  @memo = { 'id' => '', 'title' => '', 'body' => '' }
  @page_title = build_page_title('メモの作成')
  erb :edit
end

get '/memos/:id/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
    erb :error
  end
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo)
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
