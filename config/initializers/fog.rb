if Settings.carrierwave.storage == 'fog'
  CarrierWave.configure do |config|
    config.fog_directory = Settings.s3.bucket
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Settings.s3.access_key,
      :aws_secret_access_key  => Settings.s3.secret_key,
      :region                 => Settings.s3.region
    }

    config.storage :fog
  end
else
  CarrierWave.configure do |config|
    config.storage :file
    config.root = "#{Rails.root}/public"
  end
end
