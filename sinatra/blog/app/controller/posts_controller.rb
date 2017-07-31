class PostsController < ApplicationController
  namespace '/posts' do
  	# Show all
    get do
      @posts = Post.all
      erb :'posts/index'
    end

    # Create
    get '/new' do
      erb :'posts/new'
    end

    post allows: [:title, :description, :user_id] do
      @post = Post.new(params)
      
      if @post.save
        flash[:notice] = 'Post successfully created.'
        redirect '/posts'
      else
      	flash[:error] = @post.errors.full_messages
      	redirect '/posts/new'
      end
    end

    # Update
    get '/:id/:edit' do
      @post = Post.find(params[:id])
      erb :'posts/edit'
    end

    put '/:id', allows: [:id, :title, :description, :user_id, :created_at] do
      @post = Post.find(params['id'])
      @post.update(params)

      if @post.save
        flash[:notice] = 'Post successfully updated.'
        redirect '/posts'
      else
      	flash[:error] = @post.errors.full_messages
      	redirect "/posts/#{params[:id]}/edit"
      end
    end

    # Show
    get '/:id' do
      @post = Post.find(params[:id])
      erb :'posts/show'
    end

    # Destroy
    delete '/:id/delete', allows: [:id] do
      @post = Post.find(params['id'])
      @post.destroy

      flash[:notice] = 'Post successfully deleted.'
      redirect to '/posts'
    end
  end
end