class ImagesController < ApplicationController

    skip_before_action :verify_authenticity_token

    # get index (all)
    def index
      render json: Image.all
    end

    # get one (by id)
    def show
      render json: Image.find(params["id"])
    end

    # create just the image
    def create
      render json: Image.create(params["image"])
    end

    # create a image with pic
    def createWithPic
      created_location = Image.create(params["image"])
      if params["id"]
        updated_text = Text.setImage(params["id"], created_location)
      end
      render json: created_location
    end

    # delete one (by id)
    def delete
      render json: Image.delete(params["id"])
    end

    # update one (by id)
    def update
      render json: Image.update(params["id"], params["image"])
    end

end
