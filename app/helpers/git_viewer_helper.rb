module GitViewerHelper
  def file_breadcrumb
    temp = ""
    breadcrumb = [link_to( params[:repository], repos_tree_path(params[:username], params[:repository], params[:tree_hash]))]
    (params[:path] || "").split("/").each do |path|
      breadcrumb << link_to(path, repos_tree_path(params[:username], params[:repository], params[:tree_hash], "#{temp}#{path}"))
      temp = "#{temp}#{path}/"
    end
    breadcrumb.join(" › ").html_safe
  end

  def file_path(file)
    unless params[:path].nil?
      "#{params[:path]}/#{file[:path]}"
    else
      "#{file[:path]}"
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
