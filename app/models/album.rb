class Album < ApplicationRecord
    belongs_to :artist
    has_many :songs
    has_many :users, through: :album_reviews
    has_many :album_reviews
    validates_uniqueness_of :title

    def self.test 

        

        url = URI("https://deezerdevs-deezer.p.rapidapi.com/album/13204564")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'deezerdevs-deezer.p.rapidapi.com'
        request["x-rapidapi-key"] = '3f7b8337f8msh54164a2afdb63a2p12c84fjsn17115393b37d'

        response = http.request(request)
        response = JSON.parse(response.body)

            if(!response.key?("error"))
                artist = Artist.find_or_create_by(name: response["artist"]["name"], picture: response["artist"]["picture_medium"])
                if(response["genres"]["data"].length > 0)
                    album = Album.find_or_create_by(title: response["title"], cover: response["cover_medium"], artist_id: artist.id, genre: response["genres"]["data"][0]["name"], nb_tracks: response["tracks"]["data"].count, label: response["label"])
                else
                    album = Album.find_or_create_by(title: response["title"], cover: response["cover_medium"], artist_id: artist.id, genre: "N/A", nb_tracks: response["tracks"]["data"].count, label: response["label"])

                end
                
                response["tracks"]["data"].each{|track|
                    Song.find_or_create_by(album_id: album.id, duration: track["duration"], title: track["title"], preview: track["preview"], artist_name: artist.name, album_cover: album.cover)
        
                }
            end
            puts "Album Count: #{Album.all.count} | Song Count: #{Song.all.count} | Artist Count: #{Artist.all.count}"
            
        end

        def self.highest_rated
            sorted = Album.all.sort{|a, b| b.avg_rating.to_f <=> a.avg_rating.to_f}
            top12 = []
            i = 0
            while(i < 12)
                top12.push(sorted[i])
                i += 1
            end
            top12
        end

        def find_avg_rating
            reviews = self.album_reviews
            sum =0
            reviews.each{|review|
                sum+=review.rating
            }
            if(reviews.count > 0)
                new_avg = sum/reviews.count
            else
                new_avg = 0.0

            end
            
            self.update(avg_rating: new_avg.round(2))
        end

        def self.search(params)
            self.where('title LIKE ? ', "%#{params["searchTerms"]["album"]}%")
        end

    
end
