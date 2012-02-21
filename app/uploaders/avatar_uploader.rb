# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::Meta


  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end
  # Defines crop area dimensions.
  # This should be assigned before #store! and #cache! called and should be saved in the model's instance.
  # Otherwise cropped image would be lost after #recreate_versions! is called.
  # If crop area dimensions are'nt assigned, uploader calculates crop area dimensions inside the
  # parent image and creates the default image.

  delegate :thumb, :preview, to: :source

  GEOMETRY = {
    source: {width: 440.0, height: 326.0},
    thumb: {width: 220, height: 163},
    preview: {width: 100, height: 74}
  }
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :source do
    process :resize_to_fill => GEOMETRY[:source].values
    process :store_meta

    version :thumb do
      process :crop_to => GEOMETRY[:thumb].values
    end
    version :preview do
      process :crop_to => GEOMETRY[:preview].values
    end
  end

  model_delegate_attribute :x
  model_delegate_attribute :y
  model_delegate_attribute :w
  model_delegate_attribute :h


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  def max_file_size
    5242880
  end
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end


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
      Rails.logger.debug [x,y,width,height]
      Rails.logger.debug [new_width,new_height]

      cropped_img = img.crop(x, y, width, height)
      new_img = cropped_img.resize_to_fill(new_width, new_height)
      destroy_image(cropped_img)
      destroy_image(img)
      new_img
    end
  end

  # Creates the default crop image.
  # Here the original crop area dimensions are restored and assigned to the model's instance.
  def resize_to_fill_and_save_dimensions(new_width, new_height)
    manipulate! do |img|
      width, height = img.columns, img.rows
      new_img = img.resize_to_fill(new_width, new_height)
      destroy_image(img)

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
    options = options ? options.clone : {}
    {thumb: source.thumb, preview: source.preview, source: source}
  end

  private
  def crop_args
    %w(x y w h).map { |accessor| send(accessor).to_i }
  end
end
