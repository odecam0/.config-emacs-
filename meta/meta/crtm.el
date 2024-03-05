(find-metafile "convert-regions-to-markdown.el")


;; 2. Como funciona o CRTM
;; -----------------------
(find-metadefun "convert-regions-to-markdown.el" "crtm-select-region")
;; A função que realiza a busca tem alguns grupos, e encontra um deles.
(find-metadefun "convert-regions-to-markdown.el" "crtm-select-region" "search-forward-regexp")
;; Outra função decide qual função de conversão chamar, baseando-se em qual grupo foi encontrado pela funççao acima.
(find-metadefun "convert-regions-to-markdown.el" "crtm-discriminate-region")
(find-metafile "convert-regions-to-markdown.el" "if (match-string index)")


;; 3. É necessária uma funcionalidade de gerar um link para o source code no github
;;                     -------------------------------
(find-metafile "convert-regions-to-markdown.el" "(eval (read text))")
(find-metafile "convert-regions-to-markdown.el" "defvar crtm-remote-repo-url")
(find-metafile "convert-regions-to-markdown.el" "defun crtm-get-github-link-to-region")
;; A ideia é adicionar uma função logo após esse primeiro link aí. o 300
(find-metafile "convert-regions-to-markdown.el" "(crtm-get-github-link-to-region)")
;; (debug-on-entry 'crtm-get-github-link-to-region)
;; (cancel-debug-on-entry 'crtm-get-github-link-to-region)


;; 4. Exemplo gerando o markdown apropriado.
;;            -----------------------------
;; (find-soilfile "meta/banner-hide-explanation.el")
(find-soilfile "meta/helpfull-overlay.el")
(find-soilfile "static/posts/second_post.md")


;; 5. É necessário escrever o código que apresenta o markdown como uma página web.
;; (find-0soil-links)
(find-soilfile "")
(find-soilfile "src/pages/projects.js")
(find-soilfile "meta/help_on_gatsby.org")


;; 6. 
(find-soilfile "src/pages/projects.js" "import { graphql }")
(find-soilfile "src/pages/projects.js" "export const query = graphql`")
(find-soilfile "src/pages/projects.js" "const IndexPage = ({ data })")
(find-soilfile "src/pages/projects.js" "data.allMarkdownRemark.nodes.map(")
;; https://www.gatsbyjs.com/docs/tutorial/getting-started/part-6/
;; File system route api https://www.gatsbyjs.com/docs/reference/routing/file-system-route-api/
;; Query variables













