;; «.find-crmremote-links»	(to "find-crmremote-links")
;; «.find-glsl-links»	(to "find-glsl-links")
;; «.find-ytdlpmusic-links»	(to "find-ytdlpmusic-links")
;; «.find-0soil-links»	(to "find-0soil-links")



;; «find-0soil-links»  (to ".find-0soil-links")
;; Skel: (find-find-links-links-new "0soil" "remoteip" "localip")
;; Test: (find-0soil-links)

(defun brnm-get-local-ip ()
  (interactive)
  (save-window-excursion
    (shell-command "ip address")
    (switch-to-buffer shell-command-buffer-name)
    (goto-char (search-forward-regexp "wlan[0-9]"))
    (goto-char (search-forward        "inet "))
    (search-forward-regexp "[0-9]+.[0-9]+.[0-9]+.[0-9]+")
    (match-string 0)))

(defvar 0soil-localpath  nil
  "Holds the path to the project 0soil root folder on local machine")
(defvar 0soil-remotepath nil
  "Holds the path to the project 0soil's root folder on the remote machine")
(setq 0soil-localpath  "p/odecamsoil/")
(setq 0soil-remotepath "~/0soil/")
;;
(defun find-0soil-links (&optional remoteip &rest pos-spec-list)
"Visit a temporary buffer containing hyperlinks for 0soil."
  (interactive)
  (setq remoteip (or remoteip "{remoteip}"))
  (let* ((localip (brnm-get-local-ip)))
    (apply
     'find-elinks
     `((find-0soil-links ,remoteip ,@pos-spec-list)
       ;; Convention: the first sexp always regenerates the buffer.
       (find-efunction 'find-0soil-links)
       ""
       ,(ee-template0 "\
 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)
sudo systemctl start sshd
ssh brnm@{remoteip}
mkdir -p {0soil-remotepath}
sshfs odecam@{localip}:{0soil-localpath} {0soil-remotepath}
ls {0soil-remotepath}

cd {0soil-remotepath}
npx gatsby develop --host=0.0.0.0
")
       ""
       (find-soilfile "")
       (find-soilfile "src/")
       (find-soilcfile "headerLayout.js")
       (find-soilfile "meta/")
       )
     pos-spec-list)))

;; Functions to test changes in the template of `find-0soil-links'.
;; To use them type `M-x tt' inside the `(defun find-0soil-links ...)'.
;; See: (find-templates-intro "5. Debugging the meat")
;;
;; (defun ee-template-test (&rest args)
;;   (let ((ee-buffer-name "*ee-template-test*"))
;;     (find-2a nil `(find-0soil-links ,@args))))

;; (defun tt0 () (interactive) (eek "C-M-x") (ee-template-test))
;; (defun tt  () (interactive) (eek "C-M-x") (ee-template-test "192.168.1.23"))



;; «find-glsl-links»  (to ".find-glsl-links")
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

;; «find-ytdlpmusic-links»  (to ".find-ytdlpmusic-links")
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


;; «find-crmremote-links»  (to ".find-crmremote-links")
;; Skel: (find-find-links-links-new "crmremote" "local_ip remote_ip local_path remote_path" "")
;; Test: (find-crmremote-links)
;;
(defun find-crmremote-links (&optional local_ip remote_ip local_path remote_path &rest pos-spec-list)
"Visit a temporary buffer containing hyperlinks for crmremote."
  (interactive)
  (setq local_ip (or local_ip "{local_ip}"))
  (setq remote_ip (or remote_ip "{remote_ip}"))
  (setq local_path (or local_path "{local_path}"))
  (setq remote_path (or remote_path "{remote_path}"))
  (apply
   'find-elinks
   `((find-crmremote-links ,local_ip ,remote_ip ,local_path ,remote_path ,@pos-spec-list)
     ;; Convention: the first sexp always regenerates the buffer.
     (find-efunction 'find-crmremote-links)
     ""
     ,(ee-template0 "\
 (eepitch-vterm)
 (find-wset \"o_o\" '(eek \"C-u -2 s-t\"))
 (eepitch-kill)
 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)
sudo systemctl start sshd
ssh brnm@{remote_ip}
mkdir -p {remote_path}
sshfs odecam@{local_ip}:{local_path} {remote_path}
ls {remote_path}

cd {remote_path}flaskr/
source ~/.venv-crm/bin/activate
sudo systemctl start mongodb
./run_server.sh
# (find-file \"~/{local_path}flaskr/run_server.sh\")
 (find-wset \"o_o\" '(eek \"C-u -2 s-t\"))

 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)
 (find-wset \"o_2o_o\" '(eek \"C-u 2 s-t\") '(eek \"s-t\"))
ssh brnm@{remote_ip}
cd {remote_path}chronos-front/
npm start


 (eepitch-vterm)
 (eepitch-kill)
 (eepitch-vterm)
ssh brnm@{remote_ip}
python -m venv ~/.venv-crm
sshfs odecam@{local_ip}:{local_path} {remote_path}
source ~/.venv-crm/bin/activate
pip install -r {remote_path}flaskr/requirements.txt
")
     )
   pos-spec-list))


;; Functions to test changes in the template of `find-crmremote-links'.
;; To use them type `M-x tt' inside the `(defun find-crmremote-links ...)'.
;; See: (find-templates-intro "5. Debugging the meat")
;;
(defun ee-template-test (&rest args)
  (let ((ee-buffer-name "*ee-template-test*"))
    (find-2a nil `(find-crmremote-links ,@args))))

(defun tt0 () (interactive) (eek "C-M-x") (ee-template-test))
(defun tt  () (interactive) (eek "C-M-x") (ee-template-test "192.168.1.12" "192.168.1.14" "p/chronos-crm/" "~/chronos-crm/"))
