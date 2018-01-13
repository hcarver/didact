CarrierWave.configure do |config|
  config.fog_credentials = {
    aws_access_key_id: ENV["AWS_ACCESS_KEY"],
    aws_secret_access_key: ENV["AWS_SECRET"],
    provider: 'AWS',
    region: 'eu-west-1'
  }
  config.fog_directory  = ENV["FOG_DIRECTORY"]
  config.fog_public     = true
end
