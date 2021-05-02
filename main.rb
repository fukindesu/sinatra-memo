# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

APP_NAME = 'メモアプリ'

before do
  @memos = [
    { id: '1', title: 'メモ1', body: "メモの内容\nメモの内容\nメモの内容" },
    { id: '2', title: 'メモ2', body: "メモの内容\nメモの内容\nメモの内容" },
    { id: '3', title: 'メモ3', body: "メモの内容\nメモの内容\nメモの内容" },
    { id: '4', title: 'メモ4', body: "メモの内容\nメモの内容\nメモの内容" }
  ]
end

helpers do
  def find_memo(memos, params_id)
    memos.find { |memo| memo[:id] == params_id }
  end

  def build_page_title(page_title)
    [page_title, APP_NAME].compact.join(' | ')
  end
end

get '/' do
  @page_title = build_page_title(nil)
  erb :index
end

get '/memos/?' do
  redirect '/'
end

get '/memos/new/?' do
  @page_title = build_page_title('メモの作成')
  @memo = { id: '', title: '', body: '' }
  erb :edit
end

get '/memos/:id/?' do
  if (@memo = find_memo(@memos, params[:id]))
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
    erb :error
  end
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo(@memos, params[:id]))
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
