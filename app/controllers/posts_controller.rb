class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post!, only: %i[edit update destroy]

  # GET /posts
  def index
    @posts = policy_scope(Post).order(created_at: :desc)
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    authorize @post
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    authorize @post

    respond_to do |format|
      if @post.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("posts", partial: "posts/post", locals: { post: @post }),
            turbo_stream.remove("empty-state")
          ]
        end
        format.html { redirect_to posts_path, notice: "Post criado com sucesso." }
        format.json { render :show, status: :created, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "posts_error",
            html: "<p id='posts_error' class='text-red-500 text-sm'>#{@post.errors.full_messages.to_sentence}</p>"
          ), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    # Remove attachments marcados pelo front-end antes de salvar
    if params[:post][:remove_attachment_signed_ids].present?
      Array(params[:post][:remove_attachment_signed_ids]).each do |signed_id|
        blob = ActiveStorage::Blob.find_signed(signed_id) rescue nil
        @post.attachments.where(blob: blob).purge_later if blob
      end
    end

    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@post),
            partial: "posts/post",
            locals: { post: @post }
          )
        end
        format.html { redirect_to posts_path, notice: "Post atualizado." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@post),
            partial: "posts/post",
            locals: { post: @post }
          ), status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@post)) }
      format.html { redirect_to posts_path, notice: "Post removido.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  # Autorização via Pundit
  def authorize_post!
    authorize @post
  end

  def post_params
    params.require(:post).permit(:title, :description, :job_id, attachments: [])
    # remove_attachment_signed_ids é tratado manualmente no update acima
  end
end