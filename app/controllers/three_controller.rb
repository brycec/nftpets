class ThreeController < ApplicationController
  include ActionView::Helpers::AssetUrlHelper
  include Webpacker::Helper
  skip_before_action :verify_authenticity_token

  def module
    respond_to do |format|
        format.js { redirect_to asset_pack_url('three.js') }
    end
  end
end
