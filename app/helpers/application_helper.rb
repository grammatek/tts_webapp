module ApplicationHelper

  def dropzone_controller_div
    data = {
      controller: "dropzone",
      'dropzone-max-file-size'=>"8",
      'dropzone-max-files' => "10",
      'dropzone-accepted-files' => 'text/txt,text/html',
      'dropzone-dict-file-too-big' => "File is too big {{filesize}} max file size is {{maxFilesize}} MB",
      'dropzone-dict-invalid-file-type' => "Allowed file formats: .txt or .html",
    }

    content_tag :div, class: 'dropzone dropzone-default dz-clickable', data: data do
      yield
    end
  end
end
