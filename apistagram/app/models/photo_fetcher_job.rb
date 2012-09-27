class PhotoFetcherJob < Struct.new(:photo_job, :img)
  def perform
    photo_job.check_exif_and_process(img)
  end

  def error(job, exception)
    puts "==================Delayed Job Exception Starts===================="
    puts exception.message
    puts "==================Delayed Job Exception Ends===================="
    img.set_failed
  end
  
  def failure
    img.set_failed
  end
end