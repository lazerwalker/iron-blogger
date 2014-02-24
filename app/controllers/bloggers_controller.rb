class BloggersController < ApplicationController
  # GET /bloggers
  # GET /bloggers.json
  def index
    calculate_triumphs_and_shames
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bloggers }
    end
  end

  # GET /bloggers/new
  # GET /bloggers/new.json
  def new
    @blogger = Blogger.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blogger }
    end
  end

  # POST /bloggers
  # POST /bloggers.json
  def create
    @blogger = Blogger.new(params[:blogger])

    respond_to do |format|
      if @blogger.save
        format.html { redirect_to "/", notice: 'Blogger was successfully created.' }
        format.json { render json: @blogger, status: :created, location: @blogger }
      else
        format.html { render action: "new" }
        format.json { render json: @blogger.errors, status: :unprocessable_entity }
      end
    end
  end

  def email
    calculate_triumphs_and_shames
    @end_date = Blogger.first.last_week_end_date.to_date
    respond_to do |format|
      format.html
    end
  end

  private

  def calculate_triumphs_and_shames
    @bloggers = Blogger.all
    @bloggers.sort_by! { |b| b.name }.reverse!

    @triumphs = @bloggers.select { |b| b.has_blogged_last_week? }
    @triumphs.sort_by! { |b| b.streak }.reverse!

    @shames = @bloggers - @triumphs
    @shames.sort_by! { |b| b.total_owed }

    @bloggers = @triumphs + @shames
  end
end
