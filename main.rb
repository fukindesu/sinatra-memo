# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'time'
require 'securerandom'

APP_NAME = 'メモアプリ'
STORAGE_PATH = 'memo_files'

module MemoUtils
  def load_memo_files
    memos = []
    Dir.glob("#{STORAGE_PATH}/*.json", sort: false) do |filename|
      memos << JSON.parse(File.read(filename))
    end
    memos.sort_by { |memo| memo['created_at'] }
  end

  def find_memo
    file_path = memo_id_to_file_path(params['id'])
    JSON.parse(File.read(file_path)) if FileTest.exist?(file_path)
  end

  def memo_id_to_file_path(memo_id)
    "#{STORAGE_PATH}/#{memo_id}.json"
  end

  def create_memo
    create_or_update_memo(creation: true)
  end

  def create_or_update_memo(creation:)
    memo_id = (creation ? SecureRandom.uuid : params['id'])
    file_path = memo_id_to_file_path(memo_id)
    File.open(file_path, 'w') do |file|
      memo = {
        'id' => memo_id,
        'title' => (title = h(params['title']).strip).empty? ? '無題' : title,
        'body' => h(params['body']),
        'created_at' => (creation ? Time.now.iso8601 : params['created_at'])
      }
      JSON.dump(memo, file)
    end
  end

  def update_memo
    create_or_update_memo(creation: false)
  end

  def delete_memo
    file_path = memo_id_to_file_path(params['id'])
    FileTest.exist?(file_path) && File.delete(file_path)
  end
end

helpers do
  include MemoUtils
  include ERB::Util

  def build_page_title(page_title)
    [page_title, APP_NAME].compact.join(' | ')
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos/?' do
  @memos = load_memo_files
  @page_title = build_page_title(nil)
  erb :index
end

post '/memos' do
  create_memo
  redirect to('/memos')
end

get '/memos/new/?' do
  @page_title = build_page_title('メモの作成')
  erb :new
end

get '/memos/:id/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの変更')
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id/?' do
  if find_memo
    update_memo
    redirect to("/memos/#{params['id']}")
  else
    status 404
  end
end

delete '/memos/:id/?' do
  if find_memo
    delete_memo
    redirect to('/memos')
  else
    status 404
  end
end

not_found do
  @page_title = build_page_title('ページが見つかりませんでした')
  erb :error
end
