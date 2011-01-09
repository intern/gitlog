module GitViewerHelper
  def file_breadcrumb
    temp = ""
    breadcrumb = [link_to( params[:repository], repos_tree_path(params[:username], params[:repository], params[:tree_hash]))]
    path = (params[:path] || "").split("/")
    last_path = path.pop
    path.each do |path|
      breadcrumb << link_to(path, repos_tree_path(params[:username], params[:repository], params[:tree_hash], "#{temp}#{path}"))
      temp = "#{temp}#{path}/"
    end
    breadcrumb << last_path unless last_path.nil?
    breadcrumb.join(" › ").html_safe
  end

  def file_path(file)
    path = params[:path].nil? ? "#{file[:path]}" : "#{params[:path]}/#{file[:path]}"
    if file[:type] == 'tree'
      repos_tree_path(params[:username],params[:repository], params[:tree_hash], path)
    else
      repos_blob_path(params[:username],params[:repository], params[:tree_hash], path)
    end
  end

  def parser_code(code)
    code_block = []
    number = []
    i = 0
    code.each_line do |line|
      number << content_tag(:div, i+=1)
      code_block << content_tag(:div, line)
    end
    return number, code_block
  end
end
