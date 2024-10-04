class AttachmentsHandler
  
  def self.save_attachments_to_public(attachment, filename, folder)
    return unless attachment

    # Save attachment to public directory
    attachments_dir = folder
    FileUtils.mkdir_p(attachments_dir)
    file_path = File.join(attachments_dir, filename)

    # Directly write binary data to file
    begin
      File.open(file_path, 'wb') do |file|
        file.write(attachment)
      end

      file_path
    rescue StandardError => e
      puts "Error saving attachment: #{e.message}"
      nil
    end
  end
end