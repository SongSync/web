class PagesController < ApplicationController
  def home
  end

  def partial
    render '/pages/partial/' + params[:name], layout: false
  end
end
