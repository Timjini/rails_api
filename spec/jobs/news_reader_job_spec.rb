require 'rails_helper'

RSpec.describe NewsReaderJob, type: :job do
  include DataHelper
  let(:website) { 'https://www.bbc.com/' }

  before do
  end

  describe '#perform' do
      it 'saves the website payload to a cassette' do
        VCR.use_cassette('bbc_website_payload') do
          subject.perform(website)
        end
      end
      it 'fetches HTML content from the website' do
        VCR.use_cassette('bbc_website_payload') do
          html_content = HttpClient.global_get_request(website)
          expect(html_content).to include('<html')
        end
      end
      it 'extracts the website payload' do
        VCR.use_cassette('bbc_website_payload') do
          html_content = HttpClient.global_get_request(website)
          safe_html, body_content, head_lines = DocumentContentExtractor.extract_body_content(html_content)
          options = { safe_html: safe_html, body_content: body_content, head_lines: head_lines }

          content_array = news_content(options)
          content_array.each do |content|
            AttachmentsHandler.save_attachments_to_public(content[:content] , content[:title], content[:folder])
          end
          expect(content_array).to be_a(Array)
          expect(content_array).not_to be_empty 
        end
      end

  end
end
