# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Meta

  # Defines crop area dimensions.
  # This should be assigned before #store! and #cache! called and should be saved in the model's instance.
  # Otherwise cropped image would be lost after #recreate_versions! is called.
  # If crop area dimensions are'nt assigned, uploader calculates crop area dimensions inside the
  # parent image and creates the default image.

  delegate :thumb, :preview, to: :source

  GEOMETRY = {
    source: {width: 440, height: 365},
    thumb: {width: 199, height: 156},
    search_thumb: {width: 199, height: 282},
    preview: {width: 90, height: 68}
  }

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :source do
    process :resize_to_fit => GEOMETRY[:source].values
    process :store_meta
  end

  version :thumb, :from_version => :source do
    process :crop_to => GEOMETRY[:thumb].values
  end
  version :preview, :from_version => :source do
    process :crop_to => GEOMETRY[:preview].values
  end

  version :search_thumb do
    process :resize_to_fill => GEOMETRY[:search_thumb].values
  end

  model_delegate_attribute :x
  model_delegate_attribute :y
  model_delegate_attribute :w
  model_delegate_attribute :h

  def extension_white_list
    %w(jpg jpeg png)
  end

  def max_file_size
    5242880
  end

  # Crop processor
  def crop_to(width, height)
    # Checks that crop area is defined and crop should be done.
    if ((crop_args[0] == crop_args[2]) || (crop_args[1] == crop_args[3]))
      # If not creates default image and saves it's dimensions.
      resize_to_fill_and_save_dimensions(width, height)
    else
      args = crop_args + [width, height]
      crop_and_resize(*args)
    end
  end

  def crop_and_resize(x, y, width, height, new_width, new_height)
    manipulate! do |img|
      crop_params = "#{width}x#{height}+#{x}+#{y}"
      img.crop(crop_params)
      resize_to_fill(new_width, new_height)
      img
    end
  end

  # Creates the default crop image.
  # Here the original crop area dimensions are restored and assigned to the model's instance.
  def resize_to_fill_and_save_dimensions(new_width, new_height)
    manipulate! do |img|
      width, height = img[:width], img[:height]
      new_img = resize_to_fill(new_width, new_height)

      w_ratio = width.to_f / new_width.to_f
      h_ratio = height.to_f / new_height.to_f

      ratio = [w_ratio, h_ratio].min

      self.w = ratio * new_width
      self.h = ratio * new_height
      self.x = (width - self.w) / 2
      self.y = (height - self.h) / 2

      new_img
    end
  end

  def serializable_hash(options = nil)
    thumb_size = GEOMETRY[:thumb].values
    aspect_ratio = thumb_size[0].to_f/thumb_size[1].to_f
    {"aspect_ratio" => aspect_ratio}.merge Hash[versions.map { |name, version| [name, { "url" => version.url }] }]
  end

  # def serializable_hash(options = nil)
  #   options = options ? options.clone : {}
  #   {thumb: {url: thumb.url}, preview: {url: preview.url}, source: {url: source.url}, search_thumb: {url: search_thumb.url}}
  # end

private
  def crop_args
    %w(x y w h).map { |accessor| send(accessor).to_i }
  end
end
