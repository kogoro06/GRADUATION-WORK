require 'base64'

class DiagnosisController < ApplicationController
  def upload_audio
    if params[:audio_data].present?
      audio_data = params[:audio_data].split(',')[1] # Base64データ部分を取り出す
      audio_binary = Base64.decode64(audio_data)

      # public/audio フォルダが存在しない場合は作成する
      audio_dir = Rails.root.join('public', 'audio')
      FileUtils.mkdir_p(audio_dir) unless File.directory?(audio_dir)

      # 音声ファイルを保存する
      file_path = Rails.root.join('public', 'audio', "recording_#{Time.now.to_i}.webm")
      File.open(file_path, 'wb') do |file|
        file.write(audio_binary)
      end

      flash[:notice] = "Audio uploaded successfully!"

      # 仮の音声分析結果
      voice_type = analyze_audio(file_path)  # 仮のメソッド
      closest_artist = find_closest_artist(voice_type) # 仮のメソッド

      # 診断結果ページにリダイレクト
      redirect_to diagnosis_result_path(voice_type: voice_type, closest_artist: closest_artist)
    else
      flash[:alert] = "Audio upload failed."
      redirect_to diagnosis_start_path
    end
  end

  # 仮の音声分析メソッド
  def analyze_audio(file_path)
    "高音エネルギータイプ" # 仮の結果
  end

  # 仮のアーティスト検索メソッド
  def find_closest_artist(voice_type)
    "A" # 仮の結果
  end

  def result
    @voice_type = params[:voice_type]
    @closest_artist = params[:closest_artist]
  end
end
