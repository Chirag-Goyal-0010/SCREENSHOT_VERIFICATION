require 'httparty'

class PhashClient
  include HTTParty
  base_uri "http://localhost:5001"

  def self.compare(image_path, ref_path)
    options = {
      body: {
        file: File.open(image_path),
        reference: File.open(ref_path)
      }
    }
    post("/phash", options)
  end
end
