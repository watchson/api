class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :delete]

  # GET /posts
  def index
    @posts = Post.scan

    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    body = params.to_enum.to_h.map { |k, v| [k.to_sym, v] }.to_h

    @post = Post.new(body)
    @post.replace

    render json: @post, status: :created
  end

  def delete
    @post.destroy
    render json: {deleted: true}
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title)
    end
end
