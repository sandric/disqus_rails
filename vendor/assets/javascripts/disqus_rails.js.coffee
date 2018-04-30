class @DisqusRails

  constructor: (attributes)->
    @short_name = attributes['short_name']
    @public_key = attributes['public_key']
    @sso = attributes['sso']

    if attributes['remote_auth_s3'] then @remote_auth_s3 = attributes['remote_auth_s3']
    if attributes['reset'] then reset = attributes['reset']

    @registerDisqusConfig()

    if reset
      @isResetting = false
      @registerResetFunction()

  reset: ->
    unless @isResetting
      @isResetting = true
      that = this
      DISQUS.reset
        reload: true
        config: ->
          this.page.identifier = that.disqusable_id
          this.page.title = that.disqusable_title

  registerResetFunction: ->
    $(document).on "disqus:on_ready", =>
      @reset()

  registerDisqusConfig: ->
    that = this
    window.disqus_config = ->
      if that.remote_auth_s3 && that.sso
        this.page.remote_auth_s3 = that.remote_auth_s3
        this.page.api_key = that.public_key
        this.sso = that.sso

      @callbacks.afterRender = [->
        $(document).trigger "disqus:after_render"
      ]
      @callbacks.onInit = [->
        $(document).trigger "disqus:on_init"
      ]
      @callbacks.onNewComment = [ (comment) ->
        $(document).trigger "disqus:on_new_comment", [comment]
      ]
      @callbacks.onPaginate = [->
        $(document).trigger "disqus:on_paginate"
      ]
      @callbacks.onReady = [->
        $(document).trigger "disqus:on_ready"
      ]
      @callbacks.preData = [->
        $(document).trigger "disqus:pre_data"
      ]
      @callbacks.preInit = [->
        $(document).trigger "disqus:pre_init"
      ]
      @callbacks.preReset = [->
        $(document).trigger "disqus:pre_reset"
      ]

  draw_thread: (disqusable_id, disqusable_title)->

    @disqusable_id = disqusable_id
    @disqusable_title = disqusable_title

    window.disqus_shortname = @short_name
    window.disqus_identifier = @disqusable_id if @disqusable_id
    window.disqus_title = @disqusable_title || document.title

    (->
      dsq = document.createElement("script")
      dsq.type = "text/javascript"
      dsq.async = true
      dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js"
      (document.getElementsByTagName("head")[0] or document.getElementsByTagName("body")[0]).appendChild dsq
    )()
