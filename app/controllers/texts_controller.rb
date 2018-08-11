class TextsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # get index (all)
  def index
    render json: Text.all
  end

  # get one (by id)
  def show
    render json: Text.find(params["id"])
  end

  # create one
  def createOne
    render json: Text.create(params["text"])
  end

  # create a text for a image
  def createForImage
    #takes the :id for the image and converts it to image_id for text
    if params["id"]
        params["text"] = params["id"].to_i
    end
    render json: Text.create(params["text"])
  end

  # delete one (by id)
  def delete
    render json: Text.delete(params["id"])
  end

  # update one (by id)
  def update
    render json: Text.update(params["id"], params["text"])
  end

end
