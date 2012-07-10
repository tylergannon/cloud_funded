module AttachmentStubHelper
  def stub_attachments_for(klass)
    klass.any_instance.stub(:save_attached_files).and_return(true)
    klass.any_instance.stub(:destroy_attached_files).and_return(true)
    Paperclip::Attachment.any_instance.stub(:queue_all_for_delete).and_return(true)
    Paperclip::Attachment.any_instance.stub(:present?).and_return(true)
  end
end