class SphinxSearchService
  attr_reader :body, :section, :result

  SECTIONS = %w[all questions answers comments users]

  def initialize(params)
    @body = params[:q]
    @section = params[:section]
  end

  def call
    return if body == ""
    @result = if section == "all"
                 ThinkingSphinx.search body.to_s
              else
                section.singularize.capitalize.constantize.search body.to_s
              end
  end
end
