CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAIA5FOQZSINMZ22XA',                        # required unless using use_iam_profile
    aws_secret_access_key: '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',    # required unless using use_iam_profile
  }
  config.fog_directory  = 'superhibein'                                      # required
end
