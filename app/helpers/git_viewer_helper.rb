module GitViewerHelper
  def file_breadcrumb
    breadcrumb = []
    path = (params[:path] || "").split("/")
    breadcrumb << path.pop unless path.empty?
    path.count.times do |i|
      path_parts = path.join("/")
      breadcrumb << link_to(path.pop, repos_tree_path(params[:username], params[:repository], params[:tree_hash], path_parts))
    end
    breadcrumb << link_to(params[:repository], repos_tree_path(params[:username], params[:repository], params[:tree_hash]))
    breadcrumb.reverse!.join(" › ").html_safe
  end

  def file_path(file, option = nil)
    path = params[:path].nil? ? "#{file[:path]}" : "#{params[:path]}/#{file[:path]}"
    if option == :commit
      repos_diff_path(params[:username],params[:repository], params[:tree_hash], path)
    elsif option == :commits
      repos_commits_path(params[:username],params[:repository], params[:tree_hash], path)
    elsif file[:type] == 'tree'
      repos_tree_path(params[:username],params[:repository], params[:tree_hash], path)
    else
      repos_blob_path(params[:username],params[:repository], params[:tree_hash], path)
    end
  end

  def parser_code(code)
    code_blocks, numbers = [], []
    code.each_with_index do |line, index|
      code_blocks << content_tag(:div, line)
      numbers << content_tag(:div, index+1)
    end
    return numbers, code_blocks
  end

end
