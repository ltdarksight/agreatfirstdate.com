if Rails.env.staging?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJKI42B6JREZ5NB4A',
      :aws_secret_access_key  => '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'
    }
    config.fog_directory = 'GFD_Staging'
    config.storage :fog
  end
end