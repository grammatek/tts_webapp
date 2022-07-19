# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/stimulus-importmap-autoloader", to: "stimulus-importmap-autoloader.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
pin "@rails/activestorage", to: "activestorage.esm.js"

# added via  `bin/importmap pin dropzone`
pin "dropzone", to: "https://ga.jspm.io/npm:dropzone@6.0.0-beta.2/dist/dropzone.mjs"
pin "just-extend", to: "https://ga.jspm.io/npm:just-extend@5.1.1/index.esm.js"
