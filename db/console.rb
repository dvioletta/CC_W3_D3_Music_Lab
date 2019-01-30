require("pry")
require_relative("../models/album")
require_relative('../models/artist')

Album.delete_all()
Artist.delete_all()

artist1 = Artist.new({'name' => 'David Bowie'})
artist1.save()
artist2 = Artist.new({'name' => 'BMTH'})
artist2.save()

album1 = Album.new({'title' => 'Blackstar', 'genre' => 'rock', 'artist_id' => artist1.id })
album1.save()
album2 = Album.new({'title' => "Let's Dance", 'genre' => 'dance', 'artist_id' => artist1.id })
album2.save()
album3 = Album.new({'title' => 'Can You Feel My Heart', 'genre' => 'Rock', 'artist_id' => artist2.id })
album3.save()

artist = Artist.all()
album = Album.all()


binding.pry
nil
