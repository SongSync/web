# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
mime = MIME::Types["application/octet-stream"].first
mime.extensions += ["mp3", 'mp4', 'm4a', 'aac', 'ogg']
MIME::Types.index_extensions mime