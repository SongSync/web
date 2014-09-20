class PagesController < ApplicationController
  def home
  end

  def partial
    render params[:name], layout: false
  end
end
