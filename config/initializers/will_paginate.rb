# if defined?(WillPaginate)
#   module WillPaginate
#     module ActiveRecord
#       module RelationMethods
#         alias_method :per, :per_page
#         alias_method :num_pages, :total_pages
#         alias_method :prev_page, :previous_page
#         def total_count() count end
#         # alias_method :total_count, :count
#       end
#     end
#   end
# end
