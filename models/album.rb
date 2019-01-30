
require('pg')
require_relative('artist')
require_relative('../db/sqlrunner')

class Album

  attr_accessor :title, :genre, :artist_id
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @genre = options['genre']
    @id = options['id'].to_i if options['id']
    @artist_id = options['artist_id'].to_i
  end


  def save()
    db = PG.connect({ dbname: 'music_collection', host: 'localhost' })
    sql = "INSERT INTO album
    (title,
    genre,
    artist_id)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@title, @genre, @artist_id]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close()
  end

  def self.all()
  sql = "SELECT * FROM album"
  album = SqlRunner.run(sql)
  return album.map { |album| Album.new(album) }
end


  def self.delete_all()
    db = PG.connect({ dbname: 'music_collection', host: 'localhost' })
    sql = "DELETE FROM album"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def artist()
      sql = "SELECT * FROM artist WHERE id = $1"
      values = [@artist_id]
      results = SqlRunner.run( sql, values )
      artist_data = results[0]
      return Artist.new(artist_data)
    end

end
