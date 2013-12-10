class ConnectedComponentsController < ApplicationController
  before_action :set_cc, only: [:show]
  def show
  end

  private

  def set_cc
    @cc = ConnectedComponent.find(params[:id])
  end
end

