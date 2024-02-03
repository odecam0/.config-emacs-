;; <find-glsl-links>
;; Skel: (find-find-links-links-new "glsl" "filename ipaddress" "")
;; Test: (find-glsl-links)
;;
(defun find-glsl-links (&optional filename ipaddress &rest pos-spec-list)
"Visit a temporary buffer containing hyperlinks for glsl."
  (interactive)
  (setq filename (or filename "{filename}"))
  (setq ipaddress (or ipaddress "{ipaddress}"))
  (apply
   'find-elinks
   `((find-glsl-links ,filename ,ipaddress ,@pos-spec-list)
     ;; Convention: the first sexp always regenerates the buffer.
     (find-efunction 'find-glsl-links)
     ""
     (find-glslfile "")
     (find-glslfile ,filename)
     ""
     ,(ee-template0 "\
 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)
mkdir -p ~/glsl/
sshfs brnm@{ipaddress}:glsl/ ~/glsl/

ssh brnm@{ipaddress}
export DISPLAY=:0
glslViewer ~/glsl/{filename}
")
     )
   pos-spec-list))

;; <find-ytdlpmusic-links>
;; Skel: (find-find-links-links-new "ytdlpmusic" "link" "")
;; Test: (find-ytdlpmusic-links)
;;
(defun find-ytdlpmusic-links (&optional link &rest pos-spec-list)
"Visit a temporary buffer containing hyperlinks for ytdlpmusic."
  (interactive "s")
  (setq link (or link "{link}"))
  (apply
   'find-elinks
   `(
     ,(ee-template0 "\
 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)
mkdir -p ~/music/
cd ~/music/
echo \"{link}\" >> ~/downloaded_music.txt
yt-dlp -f 233 -o \"%(playlist_title)s/%(playlist_autonumber)s-%(title)s.%(ext)s\" {link}
yt-dlp -f 233 -o \"%(title)s.%(ext)s\" {link}
yt-dlp -F {link}
")
     ""
     (find-ytdlpmusic-links ,link ,@pos-spec-list)
     (find-efunction 'find-ytdlpmusic-links)
     ""
     (find-man "yt-dlp")
     (find-man "yt-dlp" "-F, --list-formats")
     (find-man "yt-dlp" "-f, --format FORMAT")
     ""
     (find-man "yt-dlp" "-o, --output [TYPES:]TEMPLATE")
     (find-man "yt-dlp" "- `playlist_autonumber`")
     ""
     (find-file "~/music/")
     (find-file "~/downloaded_music.txt")
     )
   pos-spec-list))
;; <find-spotifydl-links>
;; Skel: (find-find-links-links-new "spotifydl" "link" "")
;; Test: (find-spotifydl-links)
;;
(defun find-spotifydl-links (&optional link &rest pos-spec-list)
  "Visit a temporary buffer containing hyperlinks for spotifydl."
  (interactive "s")
  (setq link (or link "{link}"))
  (apply
   'find-elinks
   `(
     ,(ee-template0 "\
 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)

# https://developer.spotify.com/dashboard
export     SPOTIPY_CLIENT_ID=\"e9538f9cd976485881843187db8abf42\"
export SPOTIPY_CLIENT_SECRET=\"74cbc248c345450ebcf366ee3b6f7044\"

source ~/.venv/bin/activate
cd ~/music
spotify_dl --format_str \"%(playlist_title)s/%(playlist_autonumber)s-%(title)s.%(ext)s\" -l {link}
   "
		    )
     ""
     (find-sh "source ~/.venv/bin/activate; spotify_dl --help") 
     ""
     (find-spotifydl-links ,link ,@pos-spec-list)
     ;; Convention: the first sexp always regenerates the buffer.
     (find-efunction 'find-spotifydl-links)
     )
   pos-spec-list))
