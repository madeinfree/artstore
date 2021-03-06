class Admin::ProductsController < ApplicationController
	#before_action => 限定加入動作
	before_action :authenticate_user! #確保已經正確登入
	before_action :admin_required #自己添加的function

	def index
		@products = Product.all
	end

	def new
		@product = Product.new
	end

	def create
		@product = Product.new(product_params)

		@product.save

		@image = @product.photos.build(image_params)
		#@image.image = File.open('public/imageupload')
		if @image.save
			redirect_to(admin_products_path)
			flash[:message] = "上架成功！"
		else
			render :new
			flash[:message] = "上架失敗！"
		end
	end

	def show
		@product = Product.find(params[:id])
		@photo = Photo.find_by(:product_id => @product.id)
	end

	def destroy
		@product = Product.find(params[:id])
		if @product.destroy
			redirect_to(admin_products_path)
			flash[:message] = "下架成功！"
		else
			redirect_to(admin_products_path)
			flash[:message] = "下架失敗！"
		end
	end

	private

	def product_params
		params.require(:product).permit(:title, :description, :quantity, :price)
	end

	def image_params
		params.require(:product).permit(:image)
	end

end
