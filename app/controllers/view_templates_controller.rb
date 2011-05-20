class ViewTemplatesController < ApplicationController
  respond_to :html, :xml

  # GET /view_templates
  # GET /view_templates.xml
  def index
    @view_templates = ViewTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @view_templates }
    end
  end

  # GET /view_templates/1
  # GET /view_templates/1.xml
  def show
    @view_template = ViewTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @view_template }
    end
  end

  # GET /view_templates/new
  # GET /view_templates/new.xml
  def new
    @view_template = ViewTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @view_template }
    end
  end

  # GET /view_templates/1/edit
  def edit
    @view_template = ViewTemplate.find(params[:id])
  end

  # POST /view_templates
  # POST /view_templates.xml
  def create
    @view_template = ViewTemplate.new(params[:view_template])

    respond_to do |format|
      if @view_template.save
        format.html { redirect_to(@view_template, :notice => 'View template was successfully created.') }
        format.xml  { render :xml => @view_template, :status => :created, :location => @view_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @view_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /view_templates/1
  # PUT /view_templates/1.xml
  def update
    @view_template = ViewTemplate.find(params[:id])

    notice =  t("view_template.flash.notice.updated")
    if params[:revert]
      @view_template.revert(params[:revert])
      flash[:notice] = notice
    else @view_template.update_attributes(params[:view_template])
      flash[:notice] = notice
    end
    respond_with(@view_template)
  end

  # DELETE /view_templates/1
  # DELETE /view_templates/1.xml
  def destroy
    @view_template = ViewTemplate.find(params[:id])
    @view_template.destroy

    respond_to do |format|
      format.html { redirect_to(view_templates_url) }
      format.xml  { head :ok }
    end
  end
end
