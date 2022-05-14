require 'rails_helper'

RSpec.describe ImageGeneratorJob, type: :job do
  context 'generates a caption' do
    it '..' do
      caption = Caption.create(url: 'https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg' , text: 'test')

      expect(ImageGeneratorJob.perform_now(caption, 'spec/images/')).to eq true
    end
  end
end
