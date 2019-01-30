require('pg')
require_relative('../db/sqlrunner')
require_relative('album')

class Artist

  attr_reader(:id)
  attr_accessor(:name)

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    db = PG.connect({ dbname: 'music_collection', host: 'localhost' })
    sql = "INSERT INTO artist
    (name)
    VALUES
    ($1)
    RETURNING *"
    values = [@name]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close()
  end

  def self.find(id)
      db = PG.connect({ dbname: 'music_collection', host: 'localhost' })
      sql = "SELECT * FROM artist
      WHERE id = $1"
      values = [id]
      db.prepare("find", sql)
      results = db.exec_prepared("find", values)
      db.close()
      artist_hash = results.first
      artist = Artist.new(artist_hash)
      return artist
    end

    def self.all()
    sql = "SELECT * FROM artist"
    artist = SqlRunner.run(sql)
    return artist.map { |artist| Artist.new(artist) }
  end

  def self.delete_all()
    db = PG.connect({ dbname: 'music_collection', host: 'localhost' })
    sql = "DELETE FROM artist"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def album()
  sql = "SELECT * FROM album WHERE artist_id = $1"
  values = [@id]
  results = SqlRunner.run( sql, values)
  return results.map { |album| Album.new(album)}
end

end
