(find-metafile "meta-file-double-link.el")
(find-metafile "meta-file-double-link.el" "mc-meta-file-follow-link")


(find-metafile "overlay-meta-file.el")


;; CONSERTO DE INSERÇÂO DE LINK
;; ============================
(find-meta "overlay-meta-file.el" "insert_position" "brnm-find-element-in-nth-paragraph")
;; Algo está errado nesta funcionalidade daqui!
;; E por algum motivo este meta file não está fazendo certo quando mando um M-d
;; Descobri o porquê não está, mas não descobri o porquê do porquê não estar.
(find-metadefun "meta-file-double-link.el" "brnm-find-element-in-nth-paragraph")

(find-metafile "meta-file-double-link.el" "(let (group-end-pos)")
;; Modifiquei a função 'brnm-find-element-in-nth-paragraph', para que o seguinte teste
;; pudesse deixar o ponto no final do grupo, para que o link fosse inserido corretamente.
(find-metafile "meta-file-double-link.el" "brnm-find-element-in-nth-paragraph 101")


(find-soilfile "meta/helpfull-overlay.el")


;; Adicionando funcionalidade de adicionar o link no final do último grupo de links se nenhum
;; endereço for especificado.
(find-metadefun "overlay-meta-file.el" "brnm-insert-string-in-nth-position")
(find-metadefun "overlay-meta-file.el" "brnm-insert-string-in-nth-position" "(if (not num)")









