class Thessal < Racecar::Consumer
  subscribes_to 'page-crawl-complete'

  def process(message)
    Rails.logger.debug(message)
    Rails.logger.debug { "Received message: #{message.value}" }
  end
end
