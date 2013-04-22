###
	Author: Taylor Baldwin (http://tbaldw.in)

	This project is meant to make it easy to add in an info panel
	on projects. If using Markdown, the Markdown.Converter.js file
	is required as a dependency (https://code.google.com/p/pagedown/wiki/PageDown).

	Also, requires jQuery ONLY IF you choose to load in your content from an external file

	In the options object, you must include a container property which may be either
	a string or an HTML element. If you specify an 'el' property (which is to be the
	info element), it should reside outside of the container element.

###

class Info
	constructor: ( opts ) ->	

		@opts = opts

		@el = opts.el or "info"
		@btn = opts.btn or "info_btn"
		@container = opts.container or "container"
		@text = opts.text or null
		@isMarkdown = opts.isMarkdown or no
		@html = opts.html or null
		@$ = opts.$ or window.jQuery or null
		@keyTrigger = opts.keyTrigger or no
		@isOpen = no

		@el = document.getElementById @el if typeof @el is "string"
		@container = document.getElementById @container if typeof @container is "string"
		@btn = document.getElementById @btn if typeof @btn is "string"

		@createDiv() if not @el?
		@createButton() if not @btn?

		@container.className += " content_wrapper"
		@el.className += " info_container"
		@btn.className += " info_btn"
		

		if not opts.text? and not @html? and opts.textURL?
			url = opts.textURL
			arry = url.split "."
			@isMarkdown = yes if arry[arry.length - 1] is "md"

			success = (data) =>
				@text = data
				@setup()

			ajaxOpts =
				url: url
				dataType: 'text'
				type: 'GET'
				success: success

			@promise = @$.ajax ajaxOpts

		if @isMarkdown
			MDConverter = window.Markdown.Converter or window.pagedown.Converter
			@converter = new MDConverter()

		@setup() unless @promise?

	setup: ->

		@html = @text if not @html?
		@html = @converter.makeHtml @text if @isMarkdown

		@el.innerHTML = @html if @html?

		@attachEvents()

	createDiv: ->

		@el = document.createElement 'div'
		@el.id = "info"
		document.body.appendChild @el

	createButton: ->

		@btn = document.createElement 'div'
		@btn.id = "info_btn"
		@btn.innerHTML = "info"
		@container.appendChild @btn

	attachEvents: ->
		@btn.addEventListener "click", @toggleInfo

		if @keyTrigger
			document.addEventListener "keyup", (e) =>
				@toggleInfo() if e.which is 73 # the letter i

	openInfo: =>
		@el.className += " open"
		@container.className += " inactive"
		@isOpen = yes

	closeInfo: =>
		@el.className = @el.className.replace("open", "")
		@container.className = @container.className.replace("inactive", "")
		@isOpen = no

	toggleInfo: =>
		if not @isOpen
			@openInfo()
		else
			@closeInfo()

window.Info = Info