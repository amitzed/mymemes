class Text < ApplicationRecord

    # ==================================================
  #                      SET UP
  # ==================================================

  # add attribute readers for instance access
  attr_reader :id, :top_text, :bottom_text

  # connect to postgres
  DB = PG.connect(host: "localhost", port: 5432, dbname: 'mymemes_development')

  # initialize options hash
  def initialize(opts = {})
      @id = opts["id"].to_i
      @top_text = opts["top_text"]
      @bottom_text = opts["bottom_text"]
      #if image is in opts hash, show it
      if opts["image"]
        @id = opts["image"]
      end
  end

  # ==================================================
  #                      ROUTES
  # ==================================================

  # get all
  def self.all
    results = DB.exec(
        <<-SQL
            SELECT
                texts.*,
                images.top_text,
                images.bottom_text
            FROM texts
            LEFT JOIN images
                ON texts.id = images.id
        SQL
    )
    return results.map do |result|
          if result["id"]
              image = Image.new(
                  {
                      "id" => result["id"],
                      "img" => result["img"]
                  }
              )
          else
              image = nil
          end
          Text.new(
              {
                  "id" => result["id"],
                  "top_text" => result["top_text"],
                  "bottom_text" => result["bottom_text"],
              }
          )
      end
  end

  # get one by id
  def self.find(id)
      results = DB.exec(
          <<-SQL
              SELECT
                  texts.*,
                  images.img
              FROM texts
              LEFT JOIN images
                  ON texts.id = images.id
              WHERE texts.id=#{id};
          SQL
      )
      result = results.first
      if result["id"]
          image = Image.new(
              {
                  "id" => result["id"],
                  "img" => result["img"]
              }
          )
      else
          image = nil
      end
      text =  Text.new(
          {
            "id" => result["id"],
            "top_text" => result["top_text"],
            "bottom_text" => result["bottom_text"],
          }
      )
      return text
  end

  # create one
  def self.create(opts={})
    results = DB.exec(
        <<-SQL
            INSERT INTO texts (top_text, bottom_text)
            VALUES (
              '#{opts["top_text"]}',
               '#{opts["bottom_text"]}',
              #{opts["id"] ? opts["id"] : "NULL"} )
            RETURNING id, top_text, bottom_text;
        SQL
    )
    return Text.new(results.first)
  end

  # delete one (by id)
  def self.delete(id)
    results = DB.exec("DELETE FROM texts WHERE id=#{id};")
    return { deleted: true }
  end

  # update one (by id)
  def self.update(id, opts={})
    results = DB.exec(
        <<-SQL
            UPDATE texts
            SET
             top_text='#{opts["top_text"]}',
             bottom_text='#{opts["bottom_text"]}',
             id=#{opts["id"] ? opts["id"] : "NULL"}
            WHERE id=#{id}
            RETURNING id, top_text, bottom_text;
        SQL
    )
    return Text.new(results.first)
  end

  # update image text belongs to
  def self.setImage(text_id, image)
  results = DB.exec(
      <<-SQL
          UPDATE texts
          SET id = #{image.id}
          WHERE id = #{text_id}
          RETURNING id, top_text, bottom_text;
      SQL
  )
  return Text.new(results.first)
  end

end
