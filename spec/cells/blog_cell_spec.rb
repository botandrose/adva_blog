require 'rails_helper'

# TODO: Uncomment and convert when cell functionality is needed
# RSpec.describe BlogCell, type: :cell do
#   include_context :an_article
#
#   before do
#     # Clean up caching references
#     CachedPage.delete_all if defined?(CachedPage)
#     CachedPageReference.delete_all if defined?(CachedPageReference)
#
#     # Set up controller mock
#     request = double('request', path: '/path/of/request')
#     @controller = double('controller',
#       params: {},
#       perform_caching: true,
#       request: request,
#       site: site,
#       section: blog
#     )
#     @cell = BlogCell.new(@controller, nil)
#   end
#
#   describe "#render_state" do
#     it "renders recent articles" do
#       result = @cell.render_state(:recent_articles)
#       expect(result).to match(/recent \d* posts/i)
#     end
#
#     it "caches references for the assigned articles" do
#       @cell.render_state(:recent_articles)
#       reference = CachedPageReference.find_by(object_id: article.id, object_type: 'Article')
#       expect(reference).to be_instance_of(CachedPageReference)
#     end
#   end
# end