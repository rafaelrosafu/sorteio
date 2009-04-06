class RunController < ApplicationController
  # GET /candidates
  # GET /candidates.xml
  def index
    @ruby_winner = nil
    @rails_winner = nil
    session[:candidates] = Candidate.all.shuffle if session[:candidates].nil?
    @candidates = session[:candidates]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @candidates }
    end
  end
  
  def go
    @candidates = session[:candidates]

    @ruby_winner = @candidates[rand(@candidates.count)]
    @rails_winner = @candidates[rand(@candidates.count)]

    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @candidates }
    end
  end
end
