class Image < ApplicationRecord

# ==================================================
    #                      SET UP
    # ==================================================

    # add attribute readers for instance access
    attr_reader :id, :img

    # connect to postgres
    DB = PG.connect(host: "localhost", port: 5432, dbname: 'mymemes_development')

    # initialize options hash
    def initialize(opts = {})
        @id = opts["id"].to_i
        @img = opts["img"]
        if opts["pic"]
          @pic = opts["pic"]
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
                images.*,
                texts.id AS text_id,
                texts.top_text,
                texts.bottom_text
              FROM images
              LEFT JOIN texts
              ON images.id = texts.id
          SQL
      )
      images = []
      current_id = nil
      results.each do |result|
          if result["id"] != current_id
              current_id = result["id"]
              images.push(
                  Image.new({
                      "id" => result["id"],
                      "img" => result["img"],
                      "pic" => []
                  })
              )
          end
          if result["text_id"]
            p result
              new_text = Text.new(
                {
                  "id" => result["person_id"],
                  "top_text" => result["top_text"],
                  "bottom_text" => result["bottom_text"],
                }
            )
              images.last.pic.push(new_text)
          end
      end
      return images
    end

    # get one by id
    def self.find(id)
        results = DB.exec(
            <<-SQL
                SELECT
                    images.*,
                    texts.id AS text_id,
                    texts.top_text,
                    texts.bottom_text
                FROM images
                LEFT JOIN texts
                ON images.id = texts.id
                WHERE images.id=#{id};
            SQL
        )
        pic = []
        results.each do |result|
            if result["text_id"]
                pic.push Text.new(
                  {
                    "id" => result["id"],
                    "top_text" => result["top_text"],
                    "bottom_text" => result["bottom_text"],
                  }
              )
            end
        end
        return Image.new({
            "id" => results.first["id"],
            "img" => results.first["img"],
            "pic" => pic
        })
    end

    # create one
    def self.create(opts={})
        results = DB.exec(
            <<-SQL
                INSERT INTO images (img)
                VALUES ( '#{opts["img"]}' )
                RETURNING id, img;
            SQL
        )
        return Image.new(results.first)
    end

    # delete one by id
    def self.delete(id)
        results = DB.exec("DELETE FROM images WHERE id=#{id};")
        return { deleted: true }
    end

    # update one by id
    def self.update(id, opts={})
        results = DB.exec(
            <<-SQL
                UPDATE images
                SET img='#{opts["img"]}'
                WHERE id=#{id}
                RETURNING id, img;
            SQL
        )
        return Image.new(results.first)
    end

end
