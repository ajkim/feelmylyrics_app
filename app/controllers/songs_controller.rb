class SongsController < ApplicationController

API_KEY = ENV['MUSIXMATCH_KEY']

	def index
		#full lyrics



 	end


 	def new

 		
 	end

 	def create

 		@user = current_user
 		@user.name = current_user.name

 		

 		# display_lyrics(track_id)

 		@artist = params[:artist].gsub(" ", "%20")
	    @title = params[:title].gsub(" ", "%20")
	    @text = params[:text]

	    puts @text

	    url = "http://api.musixmatch.com/ws/1.1/track.search?apikey=#{ENV['MUSIXMATCH_KEY']}&q_artist=#{@artist}&q_track=#{@title}&format=json&page_size=1&f_has_lyrics=1"
	    
	    puts '*************'
	    puts url
	    puts '*************'

	    music = HTTParty.get(url)
	    saved = JSON.parse(music)

	    @track_id = saved["message"]["body"]["track_list"][0]["track"]["track_id"]

	   
 	# 	url = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?apikey=#{ENV['MUSIXMATCH_KEY']}&track_id=#{@track_id}&format=json&page_size=1&f_has_lyrics=1"

		# puts '*************'
	 #    puts url
	 #    puts '*************'

		# music = HTTParty.get(url)
	 #    hash = JSON.parse(music)



 		url = "http://api.musixmatch.com/ws/1.1/track.snippet.get?apikey=#{ENV['MUSIXMATCH_KEY']}&track_id=#{@track_id}&format=json&page_size=1&f_has_lyrics=1"

 		music = HTTParty.get(url)
	    hash = JSON.parse(music)

		@snippet = hash["message"]["body"]["snippet"]["snippet_body"]


		# @lyrics = hash["message"]["body"]["lyrics"]["lyrics_body"]


		@song = Song.create!({
			title: @title,
			artist: @artist,
			verse: @lyrics
		})

		# @post = User.find(@user.id).posts << 

		@post = Post.create!({
			song_id: @song.id,
			lyric: @snippet,
			user_id: current_user.id,
			text: @text
		})


		render :'posts/show'
 	end




 	def edit

 		# get_snippet(track_id)

 		@track_id = params[:track_id]

 		url = "http://api.musixmatch.com/ws/1.1/track.snippet.get?apikey=#{ENV['MUSIXMATCH_KEY']}&track_id=#{@track_id}&format=json&page_size=1&f_has_lyrics=1"

 		music = HTTParty.get(url)
	    saved = JSON.parse(music)

		@snippet = saved["message"]["body"]["snippet"]["snippet_body"]

		redirect_to 'posts/:id/show'

	end

	def show

		@songs = Song.all
		@posts = Post.all
		@users = User.all
		#display all in a table
	end


end